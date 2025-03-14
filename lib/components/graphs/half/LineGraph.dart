import 'package:flutter/material.dart';
import '../../graph_types.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../graph_widget.dart';

class LineGraph extends GraphWidget {
  const LineGraph({
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
