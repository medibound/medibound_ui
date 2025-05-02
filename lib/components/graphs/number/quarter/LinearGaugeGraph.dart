import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../utils/ComponentTypes.dart';
import '../../../graph_widget.dart';

class LinearGaugeGraph extends GraphWidget {
  const LinearGaugeGraph({
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
          allowedVariableForms: const [
            MBVariableForm.array,
            MBVariableForm.singleton
          ],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 1,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              variableName,
              style: FlutterFlowTheme.of(context)
                  .titleSmall
                  .copyWith(height: .9, fontSize: 10),
            ),
            if (parsedPoints.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
            else
              Row(
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
              ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value.string,
              style: TextStyle(
                fontSize: 16,
                height: 0.9,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Expanded(
              child: Text(
                " " + unit,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                      fontSize: 10,
                      height: 0.9,
                    ),
              ),
            ),
            Container(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconsMap[variable['info']?["icon"]] ?? Icons.error,
                    size: 12, color: color),
              ),
            ),
          ],
        ),
        SfLinearGauge(
          minimum: minBound,
          labelPosition: LinearLabelPosition.inside,
          maximumLabels: 3,
          maximum: maxBound,
          orientation: LinearGaugeOrientation.horizontal,
          showTicks: false,
          axisLabelStyle: const TextStyle(fontSize: 8),
          minorTicksPerInterval: 0,
          axisTrackStyle: LinearAxisTrackStyle(
            thickness: 7.5,
            edgeStyle: LinearEdgeStyle.bothCurve,
            color: color.withAlpha(20),
          ),
          barPointers: [
            LinearBarPointer(
              value: value.number,
              edgeStyle: LinearEdgeStyle.bothCurve,
              color: color,
              thickness: 7.5,
            ),
          ],
        ),
      ],
    );
  }
}
