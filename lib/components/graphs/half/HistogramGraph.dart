import 'package:flutter/material.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistogramGraph extends GraphWidget {
  const HistogramGraph({
     super.key,
    required Map<String, dynamic> variable,
    required Color color,
    required MBTimeWindow timeWindow,
    required MBTickerType tickerType,
    required MBGraphSize graphSize,
    required double height
  }) : super(
          timeWindow: timeWindow,
          tickerType: tickerType,
          graphSize: graphSize,
          variable: variable,
          color: color,
          height: height,
          allowedSizes: const [MBGraphSize.half],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array],
        );

  @override
  CartesianSeries<ChartData, String> buildSeries(BuildContext context, List<ChartData> chartData) {
    return HistogramSeries<ChartData, String>(
      dataSource: chartData,
      yValueMapper: (ChartData data, _) => data.y, // ✅ Uses only `yValueMapper`
      binInterval: 10.0, // ✅ Controls bin size
      color: color,
      dataLabelSettings: DataLabelSettings(isVisible: true), // ✅ Show labels
    );
  }
}
