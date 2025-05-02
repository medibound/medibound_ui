import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../utils/ComponentTypes.dart';
import '../../../graph_widget.dart';

class RadialGraph extends GraphWidget {
  const RadialGraph({
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
          allowedSizes: const [MBGraphSize.quarter],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array,MBVariableForm.singleton ],
        );


  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
        final List<PointData> parsedPoints = processedData.parsedPoints;

    final String unit = processedData.unit;
    final MBTimeWindow newWindow = processedData.newWindow;
    final dynamic info = processedData.info;

    if (chartData.isEmpty) {
      return const Center(
          child: Text("No Data", style: TextStyle(fontSize: 12)));
    }

    final double minBound =
        (variable['range']?['lowerBound'] as num?)?.toDouble() ?? 0.0;
    final double maxBound =
        (variable['range']?['upperBound'] as num?)?.toDouble() ?? 100.0;
    final String variableName = info?['display'] ?? "Unknown";

    final MbParsedData value =
        MBTickerTypeExtension.getValue(tickerType, chartData);

    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 5,
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align content at the bottom
      children: [
        Expanded(
          flex: 2,
          child: Column(
            spacing: 1,
            children: [
              Text(
                variableName,
                style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(height: .9, fontSize: 10),
              ),
              if (parsedPoints.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text(
                  newWindow.value.display + " ⋅ ",
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        fontSize: 10,
                        height: 0.9,
                      ),
                ),
                Text(
                  tickerType.value.display,
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        color: color,
                        fontSize: 10,
                        height: 0.9,
                      ),
                ),
              ],
            )
            else  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                      "Value",
                      style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                            fontSize: 10,
                            height: 0.9,
                          ),
                    ),
              ],
            )
            ],
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
                      axisLabelStyle: const GaugeTextStyle(fontSize: 8),
                      labelsPosition: ElementsPosition.inside,
                      maximumLabels: 2,
                      showTicks: false,
                      radiusFactor: 1.1,
                      centerY: 0.5,
                      axisLineStyle: AxisLineStyle(
                        thickness: 7.5,
                        cornerStyle: CornerStyle.bothCurve,
                        color: color.withAlpha(20),
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: value.number,
                          cornerStyle: CornerStyle.bothCurve,
                          gradient: SweepGradient(
          colors: [ color.withValues(alpha: 0.2), color],
        ),
                          width: 7.5,
                        ),
                        MarkerPointer(
                          borderColor: color,
                          markerWidth: 8,
                          markerHeight: 8,
                          markerType: MarkerType.circle,
                          borderWidth: 3,
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          value: value.number
                          )
                      ],
                    ),
                  ],
                ),
              ),
              // Centered text displaying variable name, value, and unit
              Container(
                padding: (EdgeInsets.only(top: 10)),
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 0,
                  
                  children: [
                    
                    Text(
                      value.string,
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
                    Container(
                      padding: EdgeInsets.only(top: 3, bottom: 0),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                            iconsMap[variable['info']?["icon"]] ?? Icons.error,
                            size: 12,
                            color: color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
