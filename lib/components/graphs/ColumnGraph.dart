import 'package:flutter/material.dart';
import '../graph_types.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../graph_widget.dart';

class ColumnGraph extends GraphWidget {
  const ColumnGraph({
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
    return ColumnSeries<ChartData, String>(
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
    );
  }
}
