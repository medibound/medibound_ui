
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
    MBTimeWindow.lastMinute: "Last Minute",
    MBTimeWindow.last15Minutes: "Last 15 Minutes",
    MBTimeWindow.lastHour: "Last Hour",
    MBTimeWindow.last24Hours: "Last 24 Hours",
    MBTimeWindow.last7Days: "Last 7 Days",
    MBTimeWindow.last30Days: "Last 30 Days",
    MBTimeWindow.pastYear: "Past Year",
    MBTimeWindow.auto: "Auto",
    MBTimeWindow.none: "None",
  };

  String get displayName => _names[this]!;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}



class PointData {
  PointData({required this.number, required this.timestamp, required this.label});
  final double number;
  final DateTime timestamp;
  final String label;
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

extension MBVariableTypeExtension on MBTimeWindow {
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

enum MBTickerType { last, first, mean, std, min, max, sum}

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

  String get displayName => _names[this]!;

  
}


