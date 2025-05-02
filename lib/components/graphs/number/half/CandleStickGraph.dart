import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import '../../../utils/ComponentTypes.dart';
import '../../../graph_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleStickGraph extends GraphWidget {
  const CandleStickGraph({
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
    return CandleSeries<ChartData, DateTime>(
      animationDuration: 0,
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => DateTime.parse(data.x),
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
