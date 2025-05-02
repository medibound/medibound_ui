import 'package:flutter/material.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/medibound_ui.dart';
import 'package:medibound_ui/components/utils/IconsFT.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressFlow extends StatelessWidget {
  final List<MBInfo> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final double stepCircleSize;
  final double lineHeight;
  final EdgeInsetsGeometry padding;
  
  const ProgressFlow({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.height = 120,
    this.stepCircleSize = 35,
    this.lineHeight = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? FlutterFlowTheme.of(context).primary;
    final inactive = inactiveColor ?? FlutterFlowTheme.of(context).alternate;
    
    // Calculate the percentage of completion
    final int totalSteps = steps.length;
    final double progressValue = (currentStep - 1) / (totalSteps - 1) * 100;
    
    return Container(
      height: height,
      padding: padding,
      child: SfLinearGauge(
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        animationDuration: 0,
        orientation: LinearGaugeOrientation.horizontal,
        // Track appearance
        axisTrackStyle: LinearAxisTrackStyle(
          thickness: lineHeight,
          color: inactive,
          edgeStyle: LinearEdgeStyle.bothCurve,
        ),
        // Progress bar
        barPointers: [
          LinearBarPointer(
            enableAnimation: false,
            value: progressValue,
            thickness: lineHeight,
            color: color,
            edgeStyle: LinearEdgeStyle.bothCurve,
            position: LinearElementPosition.cross,
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                color.withOpacity(0.7),
                color,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
          ),
        ],
        // Step marker pointers
        markerPointers: [
          ...List.generate(steps.length, (index) {
            final bool isCompleted = index < currentStep - 1;
            final bool isCurrent = index == currentStep - 1;
            final bool isActive = isCompleted || isCurrent;
            final MBInfo step = steps[index];
            
            // Position as percentage along the gauge
            final double position = index / (steps.length - 1) * 100;
            
            return LinearWidgetPointer(
              enableAnimation: false,
              value: position,
              position: LinearElementPosition.cross,
              offset: 0,
              child: Container(
                width: stepCircleSize,
                height: stepCircleSize,
                decoration: BoxDecoration(
                  color: isActive ? color : FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(stepCircleSize / 2),
                  border: Border.all(
                    color: isActive ? Colors.transparent : FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Icon(
                    iconsMap[step.icon] ?? Icons.circle,
                    size: stepCircleSize * 0.5,
                    color: isActive ? FlutterFlowTheme.of(context).secondaryBackground : FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            );
          }),
          // Label pointers using markers
          ...List.generate(steps.length, (index) {
            final bool isCompleted = index < currentStep - 1;
            final bool isCurrent = index == currentStep - 1;
            final bool isActive = isCompleted || isCurrent;
            final MBInfo step = steps[index];
            
            // Position as percentage along the gauge
            final double position = index / (steps.length - 1) * 100;
            
            return LinearWidgetPointer(
              value: position,
              position: LinearElementPosition.outside,
              offset: stepCircleSize * 0.7,
              enableAnimation: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  step.display,
                  style: FlutterFlowTheme.of(context).bodyMedium!.copyWith(
                    color: isActive ? color : FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
} 