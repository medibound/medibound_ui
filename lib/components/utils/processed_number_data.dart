import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'ComponentTypes.dart';

class ProcessedNumberData {
  final List<ChartData> chartData;
  final List<PointData> parsedPoints;
  final String unit;
  final dynamic info;
  final MBTimeWindow newWindow;
  final double minY;
  final double maxY;
  final DateTime minX;
  final DateTime maxX;
  final DateTime referenceTime;
  final DateTimeIntervalType dateIntervalFormat;
  final DateFormat dateFormat;
  final String labelFormat;
  final bool showAxis;
  final double interval;

  ProcessedNumberData(
      {required this.chartData,
      required this.parsedPoints,
      required this.minY,
      required this.maxY,
      required this.minX,
      required this.maxX,
      required this.newWindow,
      required this.unit,
      required this.info,
      required this.referenceTime,
      required this.dateIntervalFormat,
      required this.dateFormat,
      required this.labelFormat,
      required this.showAxis,
      required this.interval});
}

ProcessedNumberData processNumberData(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2638190097.
    Map<String, dynamic> variable,
    MBTimeWindow timeWindow,
    DateTime referenceTime) {
  final List<dynamic> points = variable["data"] ?? [];
  final String unit = variable["unit"] ?? "";
  final dynamic info = variable["info"] ?? {};
  final DateTime now = referenceTime;

  final List<PointData> parsedPoints = points.map<PointData>((data) {
    double numberValue = 0.0;
    
    // Parse the data field which now stores values as string
    if (data['data'] != null) {
      try {
        numberValue = double.parse(data['data']);
      } catch (e) {
        // If parsing fails, default to 0
        numberValue = 0.0;
      }
    }
    
    return PointData(
      number: numberValue.clamp(0, double.infinity),
      timestamp: data['timestamp'] is String
          ? DateTime.parse(data['timestamp'])
          : (data['timestamp'] is DateTime ? data['timestamp'] : now),
      label: data['data'] ?? "",
    );
  }).toList();

  parsedPoints
      .sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort ascending

  double minY = 0.0; // Default minimum value
  double maxY = parsedPoints.isNotEmpty
      ? parsedPoints.map((p) => p.number).reduce((a, b) => a > b ? a : b)
      : 0.0; // Default max if no points exist

  // Check if options.range exists and contains valid lower and upper values
  if (variable["options"] != null && 
      variable["options"]["range"] != null &&
      variable["options"]["range"]["lower"] != null &&
      variable["options"]["range"]["upper"] != null) {
    double tempMin = variable["options"]["range"]["lower"].toDouble();
    double tempMax = variable["options"]["range"]["upper"].toDouble();

    // Ensure valid range
    if (tempMin < tempMax) {
      minY = tempMin;
      maxY = tempMax;
    }
  }

  // Final check: if `minY` is not less than `maxY`, reset `minY` to 0
  if (minY >= maxY) {
    minY = 0.0;
  }

  // ✅ Determine min and max timestamps for the selected timeWindow
  DateTime minX = now.subtract(const Duration(hours: 24));
  DateTime maxX = now;

  switch (timeWindow) {
    case MBTimeWindow.lastMinute:
      minX = now.subtract(const Duration(minutes: 1));
      break;
    case MBTimeWindow.last15Minutes:
      minX = now.subtract(const Duration(minutes: 15));
      break;
    case MBTimeWindow.lastHour:
      minX = now.subtract(const Duration(hours: 1));
      break;
    case MBTimeWindow.last24Hours:
      minX = now.subtract(const Duration(hours: 24));
      break;
    case MBTimeWindow.last7Days:
      minX = now.subtract(const Duration(days: 7));
      break;
    case MBTimeWindow.last30Days:
      minX = now.subtract(const Duration(days: 30));
      break;
    case MBTimeWindow.pastYear:
      minX = now.subtract(const Duration(days: 365));
      break;
    case MBTimeWindow.none:
      if (parsedPoints.isNotEmpty) {
        minX = parsedPoints.first.timestamp;
        maxX = parsedPoints.last.timestamp;
      }
      break;
    case MBTimeWindow.auto:
      if (parsedPoints.isNotEmpty) {
        minX = parsedPoints.first.timestamp;
        maxX = parsedPoints.last.timestamp;
      }
      break;
  }

  DateTimeIntervalType dateIntervalFormat;
  DateFormat dateFormat;
  String labelFormat;
  bool showAxis = true;
  double interval;

  switch (timeWindow) {
    case MBTimeWindow.lastMinute:
      dateIntervalFormat = DateTimeIntervalType.seconds;
      dateFormat = DateFormat.s();
      labelFormat = '{value}s';
      interval = 15; // Seconds
      break;
    case MBTimeWindow.last15Minutes:
      dateIntervalFormat = DateTimeIntervalType.minutes;
      dateFormat = DateFormat.jm();
      labelFormat = '{value}';
      interval = 3; // Minutes
      break;
    case MBTimeWindow.lastHour:
      dateIntervalFormat = DateTimeIntervalType.hours;
      dateFormat = DateFormat.jm();
      labelFormat = '{value}';
      interval = 0.25; // Minutes
      break;
    case MBTimeWindow.last24Hours:
      dateIntervalFormat = DateTimeIntervalType.hours;
      dateFormat = DateFormat.j();
      labelFormat = '{value}';
      interval = 6; // Hours
      break;
    case MBTimeWindow.last7Days:
      dateIntervalFormat = DateTimeIntervalType.days;
      dateFormat = DateFormat.E();
      labelFormat = '{value}';
      interval = 1; // Day of the week (Mon, Tue, Wed)
      break;
    case MBTimeWindow.last30Days:
      dateIntervalFormat = DateTimeIntervalType.days;
      dateFormat = DateFormat.d();
      labelFormat = '{value}d';
      interval = 5; // Days
      break;
    case MBTimeWindow.pastYear:
      dateIntervalFormat = DateTimeIntervalType.months;
      dateFormat = DateFormat.LLL();
      labelFormat = '{value}';
      interval = 1; // Month (Nov, Dec)
      break;
    case MBTimeWindow.none:
      dateIntervalFormat = DateTimeIntervalType.auto;
      dateFormat = DateFormat.j();
      labelFormat = '{value}hr';
      showAxis = false;
      interval = 1;
      break;
    case MBTimeWindow.auto:
      dateIntervalFormat = DateTimeIntervalType.auto;
      dateFormat = DateFormat.j();
      labelFormat = '{value}hr';
      interval = 1; // Full date-time
      break;
    default:
      dateIntervalFormat = DateTimeIntervalType.auto;
      dateFormat = DateFormat.j();
      labelFormat = '{value}hr';
      interval = 1; // Default format
      break;
  }
  // ✅ Ensure min and max timestamps reflect actual data range
  /*if (parsedPoints.isNotEmpty) {
    minX = parsedPoints.first.timestamp.isBefore(minX) ? minX : parsedPoints.first.timestamp;
    maxX = parsedPoints.last.timestamp.isAfter(maxX) ? maxX : parsedPoints.last.timestamp;
  }*/

  // ✅ If bucketing is disabled, return raw points but still maintain X-axis range
  return ProcessedNumberData(
    chartData: parsedPoints
        .map((p) => ChartData(p.timestamp.toString(), p.number))
        .toList(),
    parsedPoints: parsedPoints,
    minY: minY,
    maxY: maxY,
    newWindow: timeWindow,
    unit: unit,
    info: info,
    maxX: maxX,
    minX: minX,
    referenceTime: referenceTime,
    dateIntervalFormat: dateIntervalFormat,
    dateFormat: dateFormat,
    labelFormat: labelFormat,
    showAxis: showAxis,
    interval: interval,
  );
}
