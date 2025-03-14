import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickGraph extends GraphWidget {
  const CandleStickGraph({
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
    return CandleSeries<ChartData, String>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      lowValueMapper: (ChartData data, _) => data.y * 0.9, // Min Blood Pressure
      highValueMapper: (ChartData data, _) =>
          data.y * 1.1, // Max Blood Pressure
      openValueMapper: (ChartData data, _) => data.y,
      closeValueMapper: (ChartData data, _) => data.y * 1.05,
      bearColor: FlutterFlowTheme.of(context).error,
      bullColor: FlutterFlowTheme.of(context).success,
    );
  }
}
