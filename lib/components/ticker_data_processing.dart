import 'package:flutter/material.dart';
import 'package:medibound_ui/components/tickers/StaticTicker.dart';
import 'package:medibound_ui/components/tickers/TrendTicker.dart';
import 'package:medibound_ui/medibound_ui.dart';
import 'graph_types.dart';
import 'dart:math' as math;

class ProcessedTickerData extends StatelessWidget {
  final List<ChartData> data;
  final BuildContext context;
  final TickerType tickerType;
  final TimeWindow timeWindow;
  final String unit;
  final dynamic info;
  final Color color;

  const ProcessedTickerData(
      {super.key,
      required this.context,
      required this.data,
      required this.info,
      required this.tickerType,
      required this.timeWindow,
      required this.unit,
      required this.color});

  @override
  Widget build(BuildContext context) {
    String timeWindowLabel() {
      switch (timeWindow) {
        case TimeWindow.lastMinute:
          return "Last 1 min";
        case TimeWindow.last15Minutes:
          return "Last 15 min";
        case TimeWindow.lastHour:
          return "Last Hour";
        case TimeWindow.last24Hours:
          return "Last 24h";
        case TimeWindow.last7Days:
          return "Last 7 days";
        case TimeWindow.last30Days:
          return "Last 30 days";
        case TimeWindow.pastYear:
          return "Past Year";
        default:
          return "";
      }
    }

    double value;
    String type;
    // Ensure there is data
    switch (tickerType) {
      case TickerType.mean:
        type = "Avg";
        value = data.map((e) => e.y).reduce((a, b) => a + b) / data.length;
        return StaticTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.min:
        type = "Min";
        value = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
        return StaticTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.max:
        type = "Max";
        value = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
        return StaticTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.last:
        type = "Latest";
        value = data.last.y;
        return TrendTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.first:
        type = "First";
        value = data.first.y;
        return TrendTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.std:
        type = "Var";
        double mean =
            data.map((e) => e.y).reduce((a, b) => a + b) / data.length;
        double variance = data
                .map((e) => (e.y - mean) * (e.y - mean))
                .reduce((a, b) => a + b) /
            data.length;
        value = math.sqrt(variance);
        return TrendTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );

      case TickerType.sum:
        type = "Sum";
        value = data.map((e) => e.y).reduce((a, b) => a + b);
        return TrendTicker(
          context: context,
          data: data,
          value: value,
          info: info,
          timeWindowLabel: timeWindowLabel(),
          color: color,
          unit: unit,
          type: type,
        );
      default:
        return Text("No Ticker Found");
    }
  }
}
