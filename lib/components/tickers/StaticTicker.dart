import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import '../graph_types.dart';

class StaticTicker extends StatelessWidget {
  final BuildContext context;
  final List<ChartData> data;
  final double value;
  final String timeWindowLabel;
  final String unit;
  final String type;
  final dynamic info;
  final Color color;

  const StaticTicker({
    super.key,
    required this.context,
    required this.data,
    required this.value,
    required this.timeWindowLabel,
    required this.unit,
    required this.type,
    required this.info,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 5,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(iconsMap[info["icon"]] ?? Icons.error,
                    size: 16, color: color),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info["displayName"] ?? "Person",
                      style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(height: .9, fontSize: 12)),
                  Row(
                    children: [
                      Text(
                        timeWindowLabel + " ⋅ ",
                        style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                              fontSize: 10,
                              height: 0.9,
                            ),
                      ),
                      Text(
                        type,
                        style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                          color: color,
                              fontSize: 10,
                              height: 0.9,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${value.toStringAsFixed(0)}",
                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                      color: color,
                      height: .9,
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
    );
  }
}
