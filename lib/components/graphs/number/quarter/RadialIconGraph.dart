import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../utils/ComponentTypes.dart';
import '../../../graph_widget.dart';

class RadialIconGraph extends GraphWidget {
  const RadialIconGraph({
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
          allowedSizes: const [MBGraphSize.half, MBGraphSize.quarter],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [
            MBVariableForm.array,
            MBVariableForm.singleton
          ],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
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

    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align content at the bottom
      children: [
        Expanded(
          flex: 2,
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
                      startAngle: 130, // Start from top
                      endAngle: 130,
                      axisLabelStyle: const GaugeTextStyle(fontSize: 8),
                      labelsPosition: ElementsPosition.inside,
                      maximumLabels: 2,
                      showTicks: false,
                      radiusFactor: 0.9,
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
                            colors: [color.withValues(alpha: 0.2), color],
                          ),
                          width: 7.5,
                        ),
                        MarkerPointer(
                            borderColor: color,
                            markerWidth: 8,
                            markerHeight: 8,
                            markerType: MarkerType.circle,
                            borderWidth: 3,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            value: value.number)
                      ],
                    ),
                  ],
                ),
              ),
              // Centered text displaying variable name, value, and unit
              Container(

                child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconsMap[variable['info']?["icon"]] ?? Icons.error,
                    size: 30, color: color),
              ),
              ),
            ],
          ),
        ),
        if (graphSize == MBGraphSize.half)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 1,
            children: [
              
              Text(
                variableName,
                style: FlutterFlowTheme.of(context)
                    .titleSmall
                    .copyWith(height: .9, fontSize: 14),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 2.5,
                children: [
                  Text(
                    newWindow.value.display + " ⋅ ",
                    style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                          fontSize: 8,
                          height: 0.9,
                        ),
                  ),
                  Text(
                    tickerType.value.display,
                    style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                          color: color,
                          fontSize: 8,
                          height: 0.9,
                        ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top:5),
                child: Row(
                  
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 0,
                    children: [
                      
                      Text(
                        value.string,
                        style: TextStyle(
                          fontSize: 24,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        " " + unit,
                        style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                              fontSize: 10,
                              height: 1,
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
