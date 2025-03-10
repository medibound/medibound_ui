import 'package:flutter/material.dart';
import '../../components/graph_types.dart';
import '../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedColumnGraph extends GraphWidget {
  const StackedColumnGraph({
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
    return StackedColumnSeries<ChartData, String>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      name: 'Values',
      borderRadius: BorderRadius.circular(2.5),
      gradient: LinearGradient(
        colors: [color, color.withValues(alpha: 0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      color: color,
    );
  }
}
