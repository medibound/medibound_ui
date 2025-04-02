import 'package:flutter/material.dart';
import '../../../graph_types.dart';
import '../../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedBarGraph extends GraphWidget {
  const StackedBarGraph({
     super.key,
    required Map<String, dynamic> variable,
    required Color color,
    required MBTimeWindow timeWindow,
    required MBTickerType tickerType,
    required MBGraphSize graphSize,
    required double height,
    required DateTime referenceTime,
  }) : super(
          timeWindow: timeWindow,
          tickerType: tickerType,
          graphSize: graphSize,
          variable: variable,
          color: color,
          height: height,
          referenceTime: referenceTime,
          allowedSizes: const [MBGraphSize.half],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array],
        );

  @override
  Widget buildWidget(BuildContext context) {
    return buildSplit(context);
  }

  @override
  CartesianSeries<ChartData, DateTime> buildSeries(BuildContext context, List<ChartData> chartData) {
    return StackedBarSeries<ChartData, DateTime>(
      animationDuration: 0,
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => DateTime.parse(data.x),
      yValueMapper: (ChartData data, _) => data.y,
      color: color,
    );
  }
}
