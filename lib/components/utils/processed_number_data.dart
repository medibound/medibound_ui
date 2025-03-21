import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import '../graph_types.dart';

class ProcessedNumberData {
  final List<ChartData> chartData;
  final List<PointData> parsedPoints;
  final String unit;
  final dynamic info;
  final MBTimeWindow newWindow;
  final double maxY;
  final int interval;

  ProcessedNumberData(
      {required this.chartData,
      required this.parsedPoints,
      required this.maxY,
      required this.interval,
      required this.newWindow,
      required this.unit,
      required this.info});
}



ProcessedNumberData processNumberData(
    Map<String, dynamic> variable, MBTimeWindow timeWindow) {
  final List<dynamic> points = variable["data"] ?? [];
  final String unit = variable["unit"] ?? "";
  final dynamic info = variable["info"] ?? {};
  final DateTime now = DateTime.now();

  final List<PointData> parsedPoints = points.map<PointData>((data) {
    return PointData(
      number: (data['number']?.toDouble() ?? 0.0).clamp(0, double.infinity),
      timestamp: data['timestamp'] is String
          ? DateTime.parse(data['timestamp'])
          : (data['timestamp'] is DateTime ? data['timestamp'] : now),
      label: data['string'] ?? "",
    );
  }).toList();

  parsedPoints
      .sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort ascending

  // Determine bucket interval & labels
  Duration bucketInterval = Duration.zero;
  int numBuckets = 0;
  int interval = 1;
  MBTimeWindow selectedWindow = MBTimeWindowExtension.getAutoWindow(timeWindow, parsedPoints);

  switch (selectedWindow) {
    case MBTimeWindow.lastMinute:
      bucketInterval = const Duration(seconds: 10);
      numBuckets = 6;
      break;
    case MBTimeWindow.last15Minutes:
      bucketInterval = const Duration(minutes: 1);
      numBuckets = 15;
      interval = 3;
      break;
    case MBTimeWindow.lastHour:
      bucketInterval = const Duration(minutes: 5);
      numBuckets = 12;
      interval = 2;
      break;
    case MBTimeWindow.last24Hours:
      bucketInterval = const Duration(hours: 1);
      numBuckets = 24;
      interval = 3;
      break;
    case MBTimeWindow.last7Days:
      bucketInterval = const Duration(days: 1);
      numBuckets = 7;
      break;
    case MBTimeWindow.last30Days:
      bucketInterval = const Duration(days: 1);
      numBuckets = 30;
      interval = 5;
      break;
    case MBTimeWindow.pastYear:
      bucketInterval = const Duration(days: 30);
      numBuckets = 12;
      interval = 1;
      break;
    case MBTimeWindow.none:
      numBuckets = parsedPoints.length;
      break;
    case MBTimeWindow.auto:
      bucketInterval = const Duration(hours: 1);
      numBuckets = 20;
      interval = 4;
      break;
  }

  List<DateTime> bucketTimestamps = List.generate(
    numBuckets + 1,
    (i) => now.subtract(bucketInterval * ((numBuckets - i))),
  );

  List<String> bucketLabels = bucketTimestamps.map((t) {
    Duration diff = now.difference(t);
    switch (selectedWindow) {
      case MBTimeWindow.lastMinute:
      case MBTimeWindow.last15Minutes:
      case MBTimeWindow.lastHour:
        return "${diff.inMinutes}m";
      case MBTimeWindow.last24Hours:
        return "${diff.inHours}h";
      case MBTimeWindow.last7Days:
        return DateFormat('EEE')
            .format(t.add(Duration(days: 1))); // "Mon", "Tue"
      case MBTimeWindow.last30Days:
        return "${diff.inDays}d";
      case MBTimeWindow.pastYear:
        return DateFormat('MMM').format(t); // "Jan", "Feb"
      default:
        return "";
    }
  }).toList();

  bucketLabels.removeLast();

  final Map<String, double> aggregatedData = {
    for (var label in bucketLabels) label: 0.0
  };

  for (var point in parsedPoints) {
    for (var i = 0; i < bucketTimestamps.length - 1; i++) {
      if (point.timestamp.isAfter(bucketTimestamps[i]) &&
          point.timestamp.isBefore(bucketTimestamps[i + 1])) {
        aggregatedData[bucketLabels[i]] =
            (aggregatedData[bucketLabels[i]] ?? 0) + point.number;
        break;
      }
    }
  }

  final List<ChartData> chartData = aggregatedData.entries
      .map((entry) => ChartData(entry.key, entry.value))
      .toList();
  double maxY = chartData.map((data) => data.y).reduce((a, b) => a > b ? a : b);

  return ProcessedNumberData(
      chartData: chartData,
      parsedPoints: parsedPoints,
      maxY: maxY,
      interval: interval,
      newWindow: selectedWindow,
      unit: unit,
      info: info);
}
