import 'package:flutter/material.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:medibound_ui/components/utils/processed_label_data.dart';
import 'package:medibound_ui/components/theme.dart';
import '../../graph_types.dart';
import '../../graph_widget.dart';

class LabelModeGraph extends GraphWidget {
  const LabelModeGraph({
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
          allowedVariableTypes: const [MBVariableType.string],
          allowedVariableForms: const [MBVariableForm.array],
        );

  @override
  Widget buildWidget(BuildContext context) {
    final processedData = processLabelData(variable, timeWindow);
    final dynamic info = processedData.info;
    final List<ChartData> chartData = processedData.chartData;

    final String variableName = info?['display'] ?? "Unknown";

    // Sort labels by frequency (highest first) and take the top 3
    final List<ChartData> topLabels = chartData
        .where((data) => data.y > 0)
        .toList()
      ..sort((a, b) => b.y.compareTo(a.y)); // Sort by frequency

    final List<ChartData> topThreeLabels = topLabels.take(3).toList();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2.5,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variableName,
                      style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(height: .9, fontSize: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          timeWindow.value.display + " ⋅ ",
                          style:
                              FlutterFlowTheme.of(context).labelSmall.copyWith(
                                    fontSize: 8,
                                    height: 0.9,
                                  ),
                        ),
                        Text(
                          "Mode",
                          style:
                              FlutterFlowTheme.of(context).labelSmall.copyWith(
                                    color: color,
                                    fontSize: 8,
                                    height: 0.9,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconsMap[variable['info']?["icon"]] ?? Icons.error,
                    size: 12, color: color),
              ),
            ],
          ),
          Column(
            children: topThreeLabels.isNotEmpty
                ? topThreeLabels.asMap().entries.map((entry) {
                    int index = entry.key; // 1-based index
                    ChartData labelData = entry.value;
                    return Container(
                      padding: EdgeInsets.only(
                          top: 2.5, bottom: 2.5, right: 5, left: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: color.withAlpha(100 - (40 * index)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "${labelData.x}", // Label with count
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .copyWith(fontSize: 10, color: color),
                            ),
                          ),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "${labelData.y.toInt()}", // Label with count
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                : [
                    Text(
                      "No Data",
                      style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
