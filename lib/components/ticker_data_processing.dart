import 'package:flutter/material.dart';
import 'package:medibound_ui/components/tickers/StaticTicker.dart';
import 'package:medibound_ui/components/tickers/TrendTicker.dart';
import 'package:medibound_ui/medibound_ui.dart';
import 'graph_types.dart';
import 'dart:math' as math;

class ProcessedTickerData extends StatelessWidget {
  final List<ChartData> data;
  final BuildContext context;
  final MBTickerType tickerType;
  final MBTimeWindow timeWindow;
  final String unit;
  final dynamic info;
  final Color color;

  const ProcessedTickerData({
    super.key,
    required this.context,
    required this.data,
    required this.info,
    required this.tickerType,
    required this.timeWindow,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String timeWindowLabel = timeWindow.displayName;
    double value = MBTickerTypeExtension.getValue(tickerType, data).number;
    String type = tickerType.shortenedDisplayName;

    return tickerType == MBTickerType.last || tickerType == MBTickerType.first
        ? TrendTicker(
            context: context,
            data: data,
            value: value,
            info: info,
            timeWindowLabel: timeWindowLabel,
            color: color,
            unit: unit,
            type: type,
          )
        : StaticTicker(
            context: context,
            data: data,
            value: value,
            info: info,
            timeWindowLabel: timeWindowLabel,
            color: color,
            unit: unit,
            type: type,
          );
  }
}
