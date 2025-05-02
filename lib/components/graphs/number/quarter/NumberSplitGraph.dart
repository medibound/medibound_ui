import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../graph_types.dart';
import '../../../graph_widget.dart';

class NumberSplitGraph extends GraphWidget {
  const NumberSplitGraph({
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
          allowedSizes: const [MBGraphSize.quarter, MBGraphSize.half],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.array],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
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
    final MbParsedData latestValue =
        MBTickerTypeExtension.getValue(MBTickerType.last, chartData);
    final String variableName = info?['display'] ?? "Unknown";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                variableName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context)
                    .titleSmall
                    .copyWith(height: 1, fontSize: 10),
              ),
            ),
            Container(
                  padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
                  child: Container(
                    width: 10,
                    height: 10,
                    
                    decoration: BoxDecoration(
                      
                      color: color.withValues(alpha: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(iconsMap[variable['info']?["icon"]] ?? Icons.error,
                        size: 12, color: color),
                  ),
                ),
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
                  latestValue.string,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: color
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
          ],
        ),
        Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  newWindow.value.display + " ⋅ ",
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        fontSize: 10,
                        height: 1,
                      ),
                ),
                Text(
                  tickerType.value.display,
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        color: color,
                        fontSize: 10,
                        height: 1,
                      ),
                ),
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
                    fontSize: 18,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: color.withValues(alpha: 100),
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
          ],
        ),
      ],
    );
  }
}
