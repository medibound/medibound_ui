import 'package:flutter/material.dart';
import 'package:medibound_ui/components/graph_types.dart';
import 'package:medibound_ui/components/graph_widget.dart';
import 'package:medibound_ui/components/utils/processed_number_data.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class ChecklistProgressGauge extends GraphWidget {
  const ChecklistProgressGauge({
    super.key,
    required super.timeWindow,
    required super.graphSize,
    required super.tickerType,
    required super.variable,
    required super.color,
    required super.height,
    required super.referenceTime,
  }) : super(
          allowedSizes: const [ MBGraphSize.half],
          allowedVariableTypes: const [MBVariableType.number],
          allowedVariableForms: const [MBVariableForm.singleton],
        );

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      children: [
        buildTicker(context),
        Expanded(child: buildProgressGauge(context)),
      ],
    );
  }

  Widget buildProgressGauge(BuildContext context) {
    final processedData = processNumberData(variable, timeWindow, referenceTime);
    final List<ChartData> chartData = processedData.chartData;
    
    if (chartData.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(fontSize: 12)));
    }

    // Get the latest value using ticker type
    final MbParsedData parsedData = MBTickerTypeExtension.getValue(tickerType, chartData);
    
    // Round to nearest integer (1-4 for steps)
    int currentStep = parsedData.number.round();
    
    // Ensure step is in valid range
    currentStep = currentStep.clamp(1, 5);
    
    // Define step labels (can be customized)
    
    // Only use 4 steps as shown in the UI
    final int totalSteps = 5;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress indicator
          Container(
            width: double.infinity,
            child: Row(
              children: List.generate(totalSteps, (index) {
                final bool isActive = index < currentStep;
                final bool isLast = index == totalSteps - 1;
                
                return Expanded(
                  child: Row(
                    children: [
                      // Step circle with improved styling
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: isActive ? color : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isActive ? [
                            BoxShadow(
                              color: color.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? FlutterFlowTheme.of(context).secondaryBackground : Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                      // Connecting line with rounded corners
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: index < currentStep - 1 ? color : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          
          // Step labels with improved styling

          // Progress indicator text
          Text(
            'Step ${currentStep} of ${totalSteps}',
            style: FlutterFlowTheme.of(context).labelSmall.copyWith(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  charts.CartesianSeries<ChartData, DateTime> buildSeries(BuildContext context, List<ChartData> chartData) {
    // Not used for this widget
    throw UnimplementedError();
  }
} 