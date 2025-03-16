import 'package:flutter/material.dart';
import '../../../graph_types.dart';
import '../../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedColumnGraph extends GraphWidget {
  const StackedColumnGraph({
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
  Widget buildWidget(BuildContext context) {
    return buildSplit(context);
  }

  @override
  CartesianSeries<ChartData, String> buildSeries(BuildContext context, List<ChartData> chartData) {
    return StackedColumnSeries<ChartData, String>(
      animationDuration: 0,
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
