import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import '../utils/ComponentTypes.dart';

class TrendTicker extends StatelessWidget {
  final BuildContext context;
  final List<ChartData> data;
  final double value;
  final String timeWindowLabel;
  final String unit;
  final String type;
  final dynamic info;
  final Color color;

  const TrendTicker({
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
    double mean = data.map((e) => e.y).reduce((a, b) => a + b) / data.length;

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
                  Text(info["display"] ?? "Person",
                      style: FlutterFlowTheme.of(context)
                          .titleSmall
                          .copyWith(height: .9, fontSize: 14)),
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
              Icon(
                  ((value > mean)
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded),
                  size: 16,
                  color: ((value > mean)
                      ? FlutterFlowTheme.of(context).success
                      : FlutterFlowTheme.of(context).error)),
              Text(
                "${value.toStringAsFixed(0)}",
                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
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
