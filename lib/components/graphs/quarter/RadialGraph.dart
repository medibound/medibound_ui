import 'package:flutter/material.dart';
import 'package:medibound_ui/components/graph_data_processing.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';

class RadialGraph extends GraphWidget {
  const RadialGraph({
    super.key,
    required Map<String, dynamic> variable,
    required Color color,
    required MBTimeWindow timeWindow,
    required MBTickerType tickerType,
    required MBGraphSize graphSize,
    required double height,
  }) : super(
          timeWindow: timeWindow,
          tickerType: tickerType,
          graphSize: graphSize,
          variable: variable,
          color: color,
          height: height,
          allowedSizes: const [MBGraphSize.quarter],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processGraphData(variable, timeWindow);
    final List<ChartData> chartData = processedData.chartData;

    if (chartData.isEmpty) {
      return const Center(child: Text("No Data", style: TextStyle(fontSize: 12)));
    }

    final double minBound = (variable['range']?['lowerBound'] as num?)?.toDouble() ?? 0.0;
    final double maxBound = (variable['range']?['upperBound'] as num?)?.toDouble() ?? 100.0;
    final String unit = variable['unit'] ?? "";
    final String variableName = variable['displayName'] ?? "Unknown";

    final double lastDataPoint = chartData.first.y.toDouble();
    String displayValue = lastDataPoint.toStringAsFixed(1);
    if (displayValue.endsWith(".0")) {
      displayValue = displayValue.substring(0, displayValue.length - 2);
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
      children: [
        Expanded(
          flex: 1,
          child: Text(
            variableName,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular radial gauge
              Container(
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: minBound,
                      maximum: maxBound,
                      showLabels: false,
                      showTicks: false,
                      radiusFactor: 1,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: color.withAlpha(20),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: lastDataPoint,
                          cornerStyle: CornerStyle.bothCurve,
                          color: color,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Centered text displaying variable name, value, and unit
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 0,
                children: [
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 18,
                      height: 0.9,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    " " + unit,
                    style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                      fontSize: 10,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}