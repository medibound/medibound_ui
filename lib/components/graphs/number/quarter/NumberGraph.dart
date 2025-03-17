import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../graph_types.dart';
import '../../../graph_widget.dart';

class NumberGraph extends GraphWidget {
  const NumberGraph({
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
          allowedSizes: const [MBGraphSize.quarter, MBGraphSize.half],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array, MBVariableForm.singleton],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow);
    final List<ChartData> chartData = processedData.chartData;
    final List<PointData> parsedPoints = processedData.parsedPoints;
    final String unit = processedData.unit;
    final dynamic info = processedData.info;
    final MBTimeWindow newWindow = processedData.newWindow;

    if (chartData.isEmpty) {
      return const Center(
          child: Text("No Data", style: TextStyle(fontSize: 12)));
    }

    final double minBound =
        (variable['range']?['lowerBound'] as num?)?.toDouble() ?? 0;
    final double maxBound =
        (variable['range']?['upperBound'] as num?)?.toDouble() ?? 100;
    final MbParsedData value =
        MBTickerTypeExtension.getValue(tickerType, chartData);
    final String variableName = info?['display'] ?? "Unknown";

    print(chartData.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 1,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconsMap[variable['info']?["icon"]] ?? Icons.error,
                    size: 14, color: color),
              ),
            ),
            Text(
              variableName,
              style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(height: .9, fontSize: 10),
            ),
            if (parsedPoints.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: [
                Text(
                  newWindow.displayName + " ⋅ ",
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        fontSize: 10,
                        height: 0.9,
                      ),
                ),
                Text(
                  tickerType.shortenedDisplayName,
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        color: color,
                        fontSize: 10,
                        height: 0.9,
                      ),
                ),
              ],
            )
            else  Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            ,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          spacing: 0,
          children: [
            
            Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value.string,
                  style: TextStyle(
                    fontSize: 24,
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
        
      ],
    );
  }
}
