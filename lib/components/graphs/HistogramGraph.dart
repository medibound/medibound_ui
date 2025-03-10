import 'package:flutter/material.dart';
import '../../components/graph_types.dart';
import '../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistogramGraph extends GraphWidget {
  const HistogramGraph({
    super.key,
    required Map<String, dynamic> variable,
    required Color color,
    required TimeWindow timeWindow,
    required TickerType tickerType,
    required GraphSize graphSize,
  }) : super(
          timeWindow: timeWindow,
          tickerType: tickerType,
          graphSize: graphSize,
          variable: variable,
          color: color,
          allowedSizes: const [GraphSize.half],
          allowedVariableTypes: const [VariableType.number],
          allowedVariableForms: const [VariableForm.array],
        );

  @override
  CartesianSeries<ChartData, String> buildSeries(List<ChartData> chartData) {
    return HistogramSeries<ChartData, String>(
      dataSource: chartData,
      yValueMapper: (ChartData data, _) => data.y, // ✅ Uses only `yValueMapper`
      binInterval: 10.0, // ✅ Controls bin size
      color: color,
      dataLabelSettings: DataLabelSettings(isVisible: true), // ✅ Show labels
    );
  }
}
