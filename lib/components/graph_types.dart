import 'dart:math' as math;

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
  static const Map<MBTimeWindow, String> _names = {
    MBTimeWindow.lastMinute: "Last 1m",
    MBTimeWindow.last15Minutes: "Last 15m",
    MBTimeWindow.lastHour: "Last 1hr",
    MBTimeWindow.last24Hours: "Last 24hrs",
    MBTimeWindow.last7Days: "Last 7d",
    MBTimeWindow.last30Days: "Last 30d",
    MBTimeWindow.pastYear: "Past 1yr",
    MBTimeWindow.auto: "Auto",
    MBTimeWindow.none: "None",
  };

  String get displayName => _names[this]!;

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
      {required this.number, required this.timestamp, required this.label});
  final double number;
  final DateTime timestamp;
  final String label;
}

class MbParsedData {
  MbParsedData({required this.number, required this.string});
  final double number;
  final String string;
}

/// Available sizes for graphs
enum MBGraphSize { quarter, half, none }

extension MBGraphSizeExtension on MBGraphSize {
  static const Map<MBGraphSize, String> _names = {
    MBGraphSize.quarter: "Quarter Size",
    MBGraphSize.half: "Half Size",
    MBGraphSize.none: "None",
  };

  String get displayName => _names[this]!;
}

/// Variable types that graphs accept
enum MBVariableType { number, string }

extension MBVariableTypeExtension on MBVariableType {
  static const Map<MBVariableType, String> _names = {
    MBVariableType.number: "Number",
    MBVariableType.string: "Label",
  };

  String get displayName => _names[this]!;
}

/// Determines if graph accepts a single value or an array
enum MBVariableForm { singleton, array }

extension MBVariableFormExtension on MBVariableForm {
  static const Map<MBVariableForm, String> _names = {
    MBVariableForm.singleton: "Singleton",
    MBVariableForm.array: "Array",
  };

  String get displayName => _names[this]!;
}

enum MBTickerType { last, first, mean, std, min, max, sum }

extension MBTickerTypeExtension on MBTickerType {
  static const Map<MBTickerType, String> _names = {
    MBTickerType.last: "Last",
    MBTickerType.first: "First",
    MBTickerType.mean: "Mean",
    MBTickerType.std: "Standard Deviation",
    MBTickerType.min: "Minimum",
    MBTickerType.max: "Maximum",
    MBTickerType.sum: "Sum",
  };

  static const Map<MBTickerType, String> _shortened = {
    MBTickerType.last: "Last",
    MBTickerType.first: "First",
    MBTickerType.mean: "Mean",
    MBTickerType.std: "Std",
    MBTickerType.min: "Min",
    MBTickerType.max: "Max",
    MBTickerType.sum: "Sum",
  };

  String get shortenedDisplayName => _shortened[this]!;

  static MbParsedData getValue(MBTickerType tickerType, List<ChartData> data) {
    if (data.isEmpty) {
      return MbParsedData(number: 0, string: '-');
    }

    double value;
    switch (tickerType) {
      case MBTickerType.last:
        value = data.last.y;
        break;
      case MBTickerType.first:
        value = data.first.y;
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
