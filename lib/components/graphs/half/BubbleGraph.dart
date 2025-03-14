import 'package:flutter/material.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BubbleGraph extends GraphWidget {
  const BubbleGraph({
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
    return BubbleSeries<ChartData, String>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      sizeValueMapper: (ChartData data, _) => data.y / 10, // Adjust bubble size
      color: color,
    );
  }
}
