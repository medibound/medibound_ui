import 'package:flutter/material.dart';
import '../graph_types.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../graph_widget.dart';

class LineGraph extends GraphWidget {
  const LineGraph({
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
    return SplineAreaSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Values',
          borderColor: color,
          borderWidth: 1.5, // Border thickness for the line
         gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
          splineType: SplineType.cardinal,
          cardinalSplineTension: 0.7,
          markerSettings: MarkerSettings(
            isVisible: false, // Show markers at data points
            height: 3,
            width: 3,
            shape: DataMarkerType.circle,
            borderWidth: 0,
            color: color,
          ),
        );
  }
}
