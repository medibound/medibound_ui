import 'package:flutter/material.dart';
import '../../components/graph_types.dart';
import '../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedBarGraph extends GraphWidget {
  const StackedBarGraph({
    super.key,
    required BuildContext context,
    required Map<String, dynamic> variable,
    required Color color,
    required TimeWindow timeWindow,
    required TickerType tickerType,
    required GraphSize graphSize,
    required double height
  }) : super(
          context: context,
          timeWindow: timeWindow,
          tickerType: tickerType,
          graphSize: graphSize,
          variable: variable,
          color: color,
          height: height,
          allowedSizes: const [GraphSize.half],
          allowedVariableTypes: const [VariableType.number],
          allowedVariableForms: const [VariableForm.array],
        );

  @override
  CartesianSeries<ChartData, String> buildSeries(List<ChartData> chartData) {
    return StackedBarSeries<ChartData, String>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      color: color,
    );
  }
}
