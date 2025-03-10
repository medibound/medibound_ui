import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'graph_types.dart';

class ProcessedGraphData {
  final List<ChartData> chartData;
  final String unit;
  final dynamic info;
  final TimeWindow newWindow;
  final double maxY;
  final int interval;

  ProcessedGraphData({required this.chartData, required this.maxY, required this.interval, required this.newWindow, required this.unit, required this.info});
}

TimeWindow getAutoWindow(TimeWindow timeWindow, List<PointData> parsedPoints) {
  TimeWindow selectedWindow = timeWindow;
  final DateTime now = DateTime.now();

  if (timeWindow == TimeWindow.auto && parsedPoints.isNotEmpty) {
    final Duration dataRange = now.difference(parsedPoints.last.timestamp);
    if (dataRange.inMinutes <= 1) selectedWindow = TimeWindow.lastMinute;
    else if (dataRange.inMinutes <= 15) selectedWindow = TimeWindow.last15Minutes;
    else if (dataRange.inMinutes <= 60) selectedWindow = TimeWindow.lastHour;
    else if (dataRange.inHours <= 24) selectedWindow = TimeWindow.last24Hours;
    else if (dataRange.inDays <= 7) selectedWindow = TimeWindow.last7Days;
    else if (dataRange.inDays <= 30) selectedWindow = TimeWindow.last30Days;
    else if (dataRange.inDays <= 365) selectedWindow = TimeWindow.pastYear;
    else selectedWindow = TimeWindow.none;
  }

  return selectedWindow;
}

ProcessedGraphData processGraphData(Map<String, dynamic> variable, TimeWindow timeWindow) {
  final List<dynamic> points = variable["data"] ?? [];
  final String unit = variable["unit"] ?? "";
  final dynamic info = variable["info"] ?? {};
  final DateTime now = DateTime.now();

  final List<PointData> parsedPoints = points.map<PointData>((data) {
    return PointData(
      number: (data['number']?.toDouble() ?? 0.0).clamp(0, double.infinity),
      timestamp: data['timestamp'] != null ? DateTime.parse(data['timestamp']) : now,
      label: data['string'] ?? "",
    );
  }).toList();

  parsedPoints.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort ascending

  // Determine bucket interval & labels
  Duration bucketInterval = Duration.zero;
  int numBuckets = 0;
  int interval = 1;
  TimeWindow selectedWindow = getAutoWindow(timeWindow, parsedPoints);

  switch (selectedWindow) {
    case TimeWindow.lastMinute:
      bucketInterval = const Duration(seconds: 10);
      numBuckets = 6;
      break;
    case TimeWindow.last15Minutes:
      bucketInterval = const Duration(minutes: 1);
      numBuckets = 15;
      interval = 3;
      break;
    case TimeWindow.lastHour:
      bucketInterval = const Duration(minutes: 5);
      numBuckets = 12;
      interval = 2;
      break;
    case TimeWindow.last24Hours:
      bucketInterval = const Duration(hours: 1);
      numBuckets = 24;
      interval = 3;
      break;
    case TimeWindow.last7Days:
      bucketInterval = const Duration(days: 1);
      numBuckets = 7;
      break;
    case TimeWindow.last30Days:
      bucketInterval = const Duration(days: 1);
      numBuckets = 30;
      interval = 5;
      break;
    case TimeWindow.pastYear:
      bucketInterval = const Duration(days: 30);
      numBuckets = 12;
      interval = 1;
      break;
    case TimeWindow.none:
      numBuckets = parsedPoints.length;
      break;
    case TimeWindow.auto:
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
      case TimeWindow.lastMinute:
      case TimeWindow.last15Minutes:
      case TimeWindow.lastHour:
        return "${diff.inMinutes}m";
      case TimeWindow.last24Hours:
        return "${diff.inHours}h";
      case TimeWindow.last7Days:
        return DateFormat('EEE').format(t.add(Duration(days: 1))); // "Mon", "Tue"
      case TimeWindow.last30Days:
        return "${diff.inDays}d";
      case TimeWindow.pastYear:
        return DateFormat('MMM').format(t); // "Jan", "Feb"
      default:
        return "";
    }
  }).toList();

  bucketLabels.removeLast();

  final Map<String, double> aggregatedData = {for (var label in bucketLabels) label: 0.0};

  for (var point in parsedPoints) {
    for (var i = 0; i < bucketTimestamps.length - 1; i++) {
      if (point.timestamp.isAfter(bucketTimestamps[i]) && point.timestamp.isBefore(bucketTimestamps[i + 1])) {
        aggregatedData[bucketLabels[i]] = (aggregatedData[bucketLabels[i]] ?? 0) + point.number;
        break;
      }
    }
  }

  final List<ChartData> chartData = aggregatedData.entries.map((entry) => ChartData(entry.key, entry.value)).toList();
  double maxY = chartData.map((data) => data.y).reduce((a, b) => a > b ? a : b);

  return ProcessedGraphData(chartData: chartData, maxY: maxY, interval: interval, newWindow: selectedWindow, unit: unit, info: info);
}
