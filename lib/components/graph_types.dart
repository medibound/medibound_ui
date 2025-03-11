
enum TimeWindow {
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

extension TimeWindowExtension on TimeWindow {
  static const Map<TimeWindow, String> _names = {
    TimeWindow.lastMinute: "Last Minute",
    TimeWindow.last15Minutes: "Last 15 Minutes",
    TimeWindow.lastHour: "Last Hour",
    TimeWindow.last24Hours: "Last 24 Hours",
    TimeWindow.last7Days: "Last 7 Days",
    TimeWindow.last30Days: "Last 30 Days",
    TimeWindow.pastYear: "Past Year",
    TimeWindow.auto: "Auto",
    TimeWindow.none: "None",
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
enum GraphSize { quarter, half, none }

extension GraphSizeExtension on GraphSize {
  static const Map<GraphSize, String> _names = {
    GraphSize.quarter: "Quarter Size",
    GraphSize.half: "Half Size",
    GraphSize.none: "None",
  };

  String get displayName => _names[this]!;
}

/// Variable types that graphs accept
enum VariableType { number, string }

/// Determines if graph accepts a single value or an array
enum VariableForm { singleton, array }

enum TickerType { last, first, mean, std, min, max, sum}

extension TickerTypeExtension on TickerType {
  static const Map<TickerType, String> _names = {
    TickerType.last: "Last",
    TickerType.first: "First",
    TickerType.mean: "Mean",
    TickerType.std: "Standard Deviation",
    TickerType.min: "Minimum",
    TickerType.max: "Maximum",
    TickerType.sum: "Sum",
  };

  String get displayName => _names[this]!;
}