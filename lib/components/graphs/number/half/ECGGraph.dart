import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/ComponentTypes.dart';
import 'package:medibound_ui/components/graph_widget.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ECGGraph extends GraphWidget {
  const ECGGraph({
    super.key,
    required super.timeWindow,
    required super.graphSize,
    required super.tickerType,
    required super.variable,
    required super.color,
    required super.height,
    required super.referenceTime,
  }) : super(
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
    return FastLineSeries<ChartData, DateTime>(
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => DateTime.parse(data.x),
      yValueMapper: (ChartData data, _) => data.y,
      color: color,
      width: 1.5,
      animationDuration: 0, // Disable animation for real-time ECG
      markerSettings: const MarkerSettings(isVisible: false),
      name: 'ECG',
      // Optional: Enable data labels to show values
      dataLabelSettings: const DataLabelSettings(
        isVisible: false,
      ),
    );
  }
  
  @override
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
    
    // Add custom grid appearance for ECG look
    return SfCartesianChart(
      enableAxisAnimation: false,
      primaryXAxis: DateTimeAxis(
        interval: interval,
        minimum: minX,
        maximum: maxX,
        intervalType: dateIntervalFormat,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: const TextStyle(fontSize: 10),
        majorTickLines: const MajorTickLines(size: 4),
        axisBorderType: AxisBorderType.withoutTopAndBottom,
        axisLine: const AxisLine(width: 1, color: Colors.grey),
        majorGridLines: const MajorGridLines(
          width: 0.5,
          color: Colors.grey,
          dashArray: <double>[5, 5],
        ),
        isVisible: showAxis,
        labelFormat: labelFormat,
        dateFormat: dateFormat,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        maximum: maxY * 1.1,
        minimum: minY * 1.1,
        interval: (maxY - minY) / 4,
        axisLine: const AxisLine(width: 1, color: Colors.grey),
        majorGridLines: const MajorGridLines(
          width: 0.5,
          color: Colors.grey,
          dashArray: <double>[5, 5],
        ),
        labelStyle: const TextStyle(fontSize: 10),
      ),
      plotAreaBorderWidth: 0,
      series: [buildSeries(context, chartData)],
      // Add vertical line tracker
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
          enable: true,
          format: 'point.y mV',
        ),
        lineType: TrackballLineType.vertical,
        lineWidth: 1,
        lineColor: Colors.grey,
      ),
    );
  }
} 