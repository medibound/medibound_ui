import 'package:flutter/material.dart';
import '../../components/graph_types.dart';
import '../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickGraph extends GraphWidget {
  const CandleStickGraph({
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
    return CandleSeries<ChartData, String>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      lowValueMapper: (ChartData data, _) => data.y * 0.9, // Min Blood Pressure
      highValueMapper: (ChartData data, _) => data.y * 1.1, // Max Blood Pressure
      openValueMapper: (ChartData data, _) => data.y,
      closeValueMapper: (ChartData data, _) => data.y * 1.05,
      bearColor: color,
      bullColor: color,
    );
  }
}
