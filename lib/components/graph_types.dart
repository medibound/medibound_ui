
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

/// Variable types that graphs accept
enum VariableType { number, string }

/// Determines if graph accepts a single value or an array
enum VariableForm { singleton, array }

enum TickerType { last, first, mean, std, sum}
