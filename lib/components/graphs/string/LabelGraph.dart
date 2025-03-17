import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:medibound_ui/components/utils/processed_label_data.dart';
import 'package:medibound_ui/components/theme.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';

class LabelGraph extends GraphWidget {
  const LabelGraph({
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
          allowedVariableTypes: const [MBVariableType.string],
          allowedVariableForms: const [MBVariableForm.singleton, MBVariableForm.array],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processLabelData(variable, timeWindow);
    final String displayLabel = processedData.label;
    final dynamic info = processedData.info;
    final List<ChartData> chartData = processedData.chartData;

    final String variableName = info?['display'] ?? "Unknown";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          
          Column(
            spacing: 2.5,
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
                    .copyWith(height: .9, fontSize: 12),
              ),
              if (chartData.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text(
                  timeWindow.displayName + " ⋅ ",
                  style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        fontSize: 10,
                        height: 0.9,
                      ),
                ),
                Text(
                  "Latest",
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
                      "Status",
                      style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                            fontSize: 10,
                            height: 0.9,
                          ),
                    ),
              ],
            ),
            ],
          ),
          
          Container(
            padding: EdgeInsets.only(top: 2.5, bottom: 2.5, right: 5, left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    displayLabel,
                    style: FlutterFlowTheme.of(context)
                        .titleSmall
                        .copyWith(fontSize: 12, color: color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
