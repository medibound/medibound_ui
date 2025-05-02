import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'ComponentTypes.dart';

class ProcessedLabelData {
  final String label;
  final dynamic info;
  final List<ChartData> chartData;

  ProcessedLabelData({required this.label, required this.info, required this.chartData});
}

ProcessedLabelData processLabelData(Map<String, dynamic> variable, MBTimeWindow timeWindow) {
  final List<dynamic> points = variable["data"] ?? [];
  final dynamic info = variable["info"] ?? {};
  final DateTime now = DateTime.now();

  // Convert points to a list of parsed PointData
  final List<PointData> parsedPoints = points.map<PointData>((data) {
    return PointData(
      data: data['data'] ?? "",
      timestamp: data['timestamp'] is String
          ? DateTime.parse(data['timestamp'])
          : (data['timestamp'] is DateTime ? data['timestamp'] : now),
    );
  }).toList();

  if (parsedPoints.isEmpty) {
    return ProcessedLabelData(label: "No Data", info: info, chartData: []);
  }

  // Determine the valid time range for the selected window
  DateTime timeLimit;
  switch (timeWindow) {
    case MBTimeWindow.lastMinute:
      timeLimit = now.subtract(const Duration(minutes: 1));
      break;
    case MBTimeWindow.last15Minutes:
      timeLimit = now.subtract(const Duration(minutes: 15));
      break;
    case MBTimeWindow.lastHour:
      timeLimit = now.subtract(const Duration(hours: 1));
      break;
    case MBTimeWindow.last24Hours:
      timeLimit = now.subtract(const Duration(hours: 24));
      break;
    case MBTimeWindow.last7Days:
      timeLimit = now.subtract(const Duration(days: 7));
      break;
    case MBTimeWindow.last30Days:
      timeLimit = now.subtract(const Duration(days: 30));
      break;
    case MBTimeWindow.pastYear:
      timeLimit = now.subtract(const Duration(days: 365));
      break;
    case MBTimeWindow.none:
    case MBTimeWindow.auto:
      timeLimit = DateTime(1970, 1, 1); // No filtering for "none" or "auto"
      break;
  }

  // Filter points based on the time window
  final List<PointData> filteredPoints = parsedPoints.where((point) {
    return point.timestamp.isAfter(timeLimit);
  }).toList();

  if (filteredPoints.isEmpty) {
    return ProcessedLabelData(label: "No Data", info: info, chartData: []);
  }

  // Compute the frequency of labels in the filtered dataset
  final Map<String, int> frequencyMap = {};
  for (var point in filteredPoints) {
    final labelString = point.data.toString();
    frequencyMap[labelString] = (frequencyMap[labelString] ?? 0) + 1;
  }

  // Find the mode (most frequent label)
  String mostFrequentLabel = frequencyMap.entries
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;
      
  String latestLabel = filteredPoints.last.data;

  // Convert frequency data into ChartData format
  List<ChartData> chartData = frequencyMap.entries
      .map((entry) => ChartData(entry.key, entry.value.toDouble()))
      .toList();

  return ProcessedLabelData(label: latestLabel, info: info, chartData: chartData);
}
