import 'package:flutter/material.dart';
import '../../../graph_types.dart';
import '../../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepLineGraph extends GraphWidget {
  const StepLineGraph({
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
    return  buildSplit(context);
  }

  @override
  CartesianSeries<ChartData, String> buildSeries(BuildContext context, List<ChartData> chartData) {
    return StepLineSeries<ChartData, String>(
      animationDuration: 0,
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      color: color,
    );
  }
}
