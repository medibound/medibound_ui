import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:medibound_ui/medibound_ui.dart';


enum MBTimeWindow {
  lastMinute,
  last15Minutes,
  lastHour,
  last24Hours,
  last7Days,
  last30Days,
  pastYear,
  auto,
  none
}

extension MBTimeWindowExtension on MBTimeWindow {
  static Map<MBTimeWindow, MBInfo> _values = {
    MBTimeWindow.lastMinute: MBInfo(
      display: "Last 1m",
      code: "lastMinute",
      description: "Data from the last minute",
      icon: "timer",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.last15Minutes: MBInfo(
      display: "Last 15m",
      code: "last15Minutes",
      description: "Data from the last 15 minutes",
      icon: "timelapse",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.lastHour: MBInfo(
      display: "Last 1hr",
      code: "lastHour",
      description: "Data from the last hour",
      icon: "hourglass_top",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.last24Hours: MBInfo(
      display: "Last 24hrs",
      code: "last24Hours",
      description: "Data from the last 24 hours",
      icon: "access_time",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.last7Days: MBInfo(
      display: "Last 7d",
      code: "last7Days",
      description: "Data from the last 7 days",
      icon: "date_range",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.last30Days: MBInfo(
      display: "Last 30d",
      code: "last30Days",
      description: "Data from the last 30 days",
      icon: "calendar_month",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.pastYear: MBInfo(
      display: "Past 1yr",
      code: "pastYear",
      description: "Data from the past year",
      icon: "calendar_today",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.auto: MBInfo(
      display: "Auto",
      code: "auto",
      description: "Automatically select time window based on data",
      icon: "auto_awesome",
      color: getMBColorByName('Slate'),
    ),
    MBTimeWindow.none: MBInfo(
      display: "None",
      code: "none",
      description: "No time window filter",
      icon: "all_inclusive",
      color: getMBColorByName('Slate'),
    ),
  };

  MBInfo get value => _values[this]!;


  static MBTimeWindow getAutoWindow(
      MBTimeWindow timeWindow, List<PointData> parsedPoints) {
    MBTimeWindow selectedWindow = timeWindow;
    final DateTime now = DateTime.now();

    if (timeWindow == MBTimeWindow.auto && parsedPoints.isNotEmpty) {
      final Duration dataRange = now.difference(parsedPoints.last.timestamp);
      if (dataRange.inMinutes <= 1)
        selectedWindow = MBTimeWindow.lastMinute;
      else if (dataRange.inMinutes <= 15)
        selectedWindow = MBTimeWindow.last15Minutes;
      else if (dataRange.inMinutes <= 60)
        selectedWindow = MBTimeWindow.lastHour;
      else if (dataRange.inHours <= 24)
        selectedWindow = MBTimeWindow.last24Hours;
      else if (dataRange.inDays <= 7)
        selectedWindow = MBTimeWindow.last7Days;
      else if (dataRange.inDays <= 30)
        selectedWindow = MBTimeWindow.last30Days;
      else if (dataRange.inDays <= 365)
        selectedWindow = MBTimeWindow.pastYear;
      else
        selectedWindow = MBTimeWindow.none;
    }

    return selectedWindow;
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class PointData {
  PointData(
      {required this.data, required this.timestamp});
  final dynamic data;
  final DateTime timestamp;
}

class MbParsedData {
  MbParsedData({required this.number, required this.string});
  final double number;
  final String string;
}

/// Available sizes for graphs
enum MBGraphSize { quarter, half, none }

extension MBGraphSizeExtension on MBGraphSize {
  static Map<MBGraphSize, MBInfo> _values = {
    MBGraphSize.quarter: MBInfo(
      display: "Quarter Size",
      code: "quarter",
      description: "Graph takes up a quarter of the available space",
      icon: "grid_view_rounded",
      color: getMBColorByName('Slate'),
    ),
    MBGraphSize.half: MBInfo(
      display: "Half Size",
      code: "half",
      description: "Graph takes up half of the available space",
      icon: "view_agenda_rounded",
      color: getMBColorByName('Slate'),
    ),
    MBGraphSize.none: MBInfo(
      display: "None",
      code: "none",
      description: "Graph has no fixed size",
      icon: "aspect_ratio",
      color: getMBColorByName('Slate'),
    ),
  };

  MBInfo get value => _values[this]!;
}

/// Variable types that graphs accept
enum MBVariableType { number, string }

extension MBVariableTypeExtension on MBVariableType {
  static Map<MBVariableType, MBInfo> _values = {
    MBVariableType.number: MBInfo(
      display: "Number",
      code: "number",
      description: "Numeric data type for quantitative values",
      icon: "numbers",
      color: getMBColorByName('Slate'),
    ),
    MBVariableType.string: MBInfo(
      display: "Label",
      code: "string",
      description: "Text data type for categorical values",
      icon: "text_fields",
      color: getMBColorByName('Slate'),
    ),
  };

  MBInfo get value => _values[this]!;
}

/// Determines if graph accepts a single value or an array
enum MBVariableForm { singleton, array }

extension MBVariableFormExtension on MBVariableForm {
  static Map<MBVariableForm, MBInfo> _values = {
    MBVariableForm.singleton: MBInfo(
      display: "Singleton",
      code: "singleton",
      description: "Graph accepts a single value",
      icon: "filter_1",
      color: getMBColorByName('Slate'),
    ),
    MBVariableForm.array: MBInfo(
      display: "Array",
      code: "array",
      description: "Graph accepts an array of values",
      icon: "view_list",
      color: getMBColorByName('Slate'),
    ),
  };

  MBInfo get value => _values[this]!;
 
}

enum MBTickerType { last, first, mean, std, min, max, sum }

extension MBTickerTypeExtension on MBTickerType {
  static Map<MBTickerType, MBInfo> _values = {
    MBTickerType.last: MBInfo(
      display: "Last",
      code: "last",
      description: "Shows the last value in the dataset",
      icon: "last_page",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.first: MBInfo(
      display: "First",
      code: "first",
      description: "Shows the first value in the dataset",
      icon: "first_page",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.mean: MBInfo(
      display: "Mean",
      code: "mean",
      description: "Shows the average of all values",
      icon: "calculate",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.std: MBInfo(
      display: "Std",
      code: "std",
      description: "Shows how spread out the values are",
      icon: "show_chart",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.min: MBInfo(
      display: "Min",
      code: "min",
      description: "Shows the smallest value in the dataset",
      icon: "arrow_downward",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.max: MBInfo(
      display: "Max",
      code: "max",
      description: "Shows the largest value in the dataset",
      icon: "arrow_upward",
      color: getMBColorByName('Slate'),
    ),
    MBTickerType.sum: MBInfo(
      display: "Sum",
      code: "sum",
      description: "Shows the total of all values",
      icon: "functions",
      color: getMBColorByName('Slate'),
    ),
  };

  MBInfo get value => _values[this]!;

  static MbParsedData getValue(MBTickerType tickerType, List<ChartData> data) {
    if (data.isEmpty) {
      return MbParsedData(number: 0, string: '-');
    }

    double value;
    switch (tickerType) {
      case MBTickerType.last:
        value = data.first.y;
        break;
      case MBTickerType.first:
        value = data.last.y;
        break;
      case MBTickerType.mean:
        value = data.map((e) => e.y).reduce((a, b) => a + b) / data.length;
        break;
      case MBTickerType.std:
        double mean =
            data.map((e) => e.y).reduce((a, b) => a + b) / data.length;
        double variance = data
                .map((e) => (e.y - mean) * (e.y - mean))
                .reduce((a, b) => a + b) /
            data.length;
        value = math.sqrt(variance);
        break;
      case MBTickerType.min:
        value = data.map((e) => e.y).reduce(math.min);
        break;
      case MBTickerType.max:
        value = data.map((e) => e.y).reduce(math.max);
        break;
      case MBTickerType.sum:
        value = data.map((e) => e.y).reduce((a, b) => a + b);
        break;
    }

    String displayValue = value.toStringAsFixed(1);
    if (displayValue.endsWith(".0")) {
      displayValue = displayValue.substring(0, displayValue.length - 2);
    }
    return MbParsedData(number: value, string: displayValue);
  }
}
