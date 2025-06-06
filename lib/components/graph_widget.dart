import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/layouts/HalfSize.dart';
import '../components/layouts/QuarterSize.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'utils/ComponentTypes.dart';
import 'utils/processed_number_data.dart';
import 'ticker_data_processing.dart';

abstract class GraphWidget extends StatelessWidget {
  final MBTimeWindow timeWindow;
  final MBGraphSize graphSize;
  final MBTickerType tickerType;
  final Map<String, dynamic> variable;
  final Color color;
  final double height;
  final DateTime referenceTime;

  /// Defines constraints for each graph type
  final List<MBGraphSize> allowedSizes;
  final List<MBVariableType> allowedVariableTypes;
  final List<MBVariableForm> allowedVariableForms;

  const GraphWidget({
    super.key,
    required this.graphSize,
    required this.tickerType,
    required this.timeWindow,
    required this.variable,
    required this.color,
    required this.height,
    required this.allowedSizes,
    required this.allowedVariableTypes,
    required this.allowedVariableForms,
    required this.referenceTime
  });

  @override
  Widget build(BuildContext context) {
    return buildSize(context);
  }

  Widget buildTicker(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
    final String unit = processedData.unit;
    final MBTimeWindow newWindow = processedData.newWindow;
    final dynamic info = processedData.info;

    return ProcessedTickerData(
        context: context,
        data: chartData,
        tickerType: tickerType,
        timeWindow: newWindow,
        color: color,
        unit: unit,
        info: info);
  }

  Widget buildSize(BuildContext context) {
    switch (graphSize) {
      case MBGraphSize.half:
        return HalfSize(
            context: context, child: buildWidget(context), height: height);
      case MBGraphSize.quarter:
        return QuarterSize(
            context: context, child: buildWidget(context), height: height);
      default:
        return QuarterSize(
            context: context, child: Text('No Size Selected'), height: height);
    }
  }

  Widget buildSplit(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
      children: [
        Expanded(
          flex: 1, // Takes 1/3 of the space
          child: Align(
            alignment: Alignment.center,
            child: buildTicker(context),
          ),
        ),
        Expanded(
          flex: 2, // Takes 2/3 of the space
          child: ClipRect(
            // ✅ Ensures no overflow outside the defined space
            child: buildGraph(context), // The graph or content
          ),
        ),
      ],
    );
  }

  Widget buildGraph(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
    final DateTimeIntervalType dateIntervalFormat = processedData.dateIntervalFormat;
    final DateFormat dateFormat = processedData.dateFormat;
    final String labelFormat = processedData.labelFormat;
    final double interval = processedData.interval;
    final bool showAxis = processedData.showAxis;
    final double maxY = processedData.maxY;
    final double minY = processedData.minY;
    final DateTime minX = processedData.minX;
    final DateTime maxX = processedData.maxX;

    return SfCartesianChart(
      enableAxisAnimation: false,
      primaryXAxis: DateTimeAxis(
        interval: interval,
        minimum: minX, // ✅ Dynamically set min timestamp
        maximum: maxX, // ✅ Dynamically set max timestamp
        intervalType: dateIntervalFormat,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: const TextStyle(fontSize: 8),
        majorTickLines: const MajorTickLines(size: 4),
        axisBorderType: AxisBorderType.withoutTopAndBottom,
        axisLine: AxisLine(dashArray: [3]),
        majorGridLines: const MajorGridLines(width: 0),
        placeLabelsNearAxisLine: true,
        isVisible: showAxis,
        labelFormat: labelFormat,
        dateFormat: dateFormat,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        maximum: maxY * 1.1,
        minimum: minY,
        plotOffsetEnd: maxY * 0.02,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      series: [buildSeries(context, chartData)],
    );
  }

  CartesianSeries<ChartData, DateTime> buildSeries(
      BuildContext context, List<ChartData> chartData) {
    throw UnimplementedError();
  }

  Widget buildWidget(BuildContext context) {
    throw UnimplementedError();
  }
}
