import 'package:flutter/material.dart';
import '../components/layouts/HalfSize.dart';
import '../components/layouts/QuarterSize.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_types.dart';
import 'graph_data_processing.dart';
import 'ticker_data_processing.dart';

abstract class GraphWidget extends StatelessWidget {
  final TimeWindow timeWindow;
  final GraphSize graphSize;
  final TickerType tickerType;
  final Map<String, dynamic> variable;
  final Color color;
  final BuildContext context;

  /// Defines constraints for each graph type
  final List<GraphSize> allowedSizes;
  final List<VariableType> allowedVariableTypes;
  final List<VariableForm> allowedVariableForms;

  const GraphWidget({
    super.key,
    required this.context,
    required this.graphSize,
    required this.tickerType,
    required this.timeWindow,
    required this.variable,
    required this.color,
    required this.allowedSizes,
    required this.allowedVariableTypes,
    required this.allowedVariableForms,
  });

  @override
  Widget build(BuildContext context) {
    return buildSize(context);
  }

  Widget buildTicker(BuildContext context) {
    final processedData = processGraphData(variable, timeWindow);
    final List<ChartData> chartData = processedData.chartData;
    final String unit = processedData.unit;
    final TimeWindow newWindow = processedData.newWindow;
    final dynamic info = processedData.info;

    return ProcessedTickerData(context: context, data: chartData, tickerType: tickerType, timeWindow: newWindow, color: color, unit: unit, info: info);
  }

  Widget buildSize(BuildContext context) {
    

    switch (graphSize) {
      case GraphSize.half:
        return HalfSize(context: context, child: buildGraph(context), tickerChild: buildTicker(context));
      case GraphSize.quarter:
        return QuarterSize(context: context, child: buildGraph(context));
      default:
        return QuarterSize(context: context, child: Text('No Size Selected'));
    }
  }

  Widget buildGraph(BuildContext context) {
    final processedData = processGraphData(variable, timeWindow);
    final List<ChartData> chartData = processedData.chartData;
    final double maxY = processedData.maxY;

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.betweenTicks,
        interval: processedData.interval.toDouble(),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: const TextStyle(fontSize: 8),
        majorTickLines: const MajorTickLines(size: 4),
        axisBorderType: AxisBorderType.withoutTopAndBottom,
        axisLine: AxisLine(dashArray: [3]),
        majorGridLines: const MajorGridLines(width: 0),
        placeLabelsNearAxisLine: true,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        maximum: maxY,
        plotOffsetEnd: maxY*0.02,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      series: [buildSeries(chartData)],
    );
  }

  CartesianSeries<ChartData, String> buildSeries(List<ChartData> chartData);
}
