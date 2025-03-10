import 'package:flutter/material.dart';
import '../components/graph_types.dart';
import '../components/graph_widget.dart';
import '../components/graphs/BubbleGraph.dart';
import '../components/graphs/CandleStickGraph.dart';
import '../components/graphs/ColumnGraph.dart';
import '../components/graphs/FastLineGraph.dart';
import '../components/graphs/LineGraph.dart';
import '../components/graphs/ScatterGraph.dart';
import '../components/graphs/StackedColumnGraph.dart';
import '../components/graphs/StepLineGraph.dart';

typedef GraphBuilderFunction = GraphWidget Function(
    BuildContext context, Map<String, dynamic> variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize);

final Map<String, GraphBuilderFunction> widgetRegistry = {
  "Column": (context, variable, color, timeWindow, tickerType, graphSize) => ColumnGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Line": (context, variable, color, timeWindow, tickerType, graphSize) => LineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Scatter": (context, variable, color, timeWindow, tickerType, graphSize) => ScatterGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "StepLine": (context, variable, color, timeWindow, tickerType, graphSize) => StepLineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "FastLine": (context, variable, color, timeWindow, tickerType, graphSize) => FastLineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  //"Histogram": (context, variable, color, timeWindow, tickerType, graphSize) => HistogramGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Bubble": (context, variable, color, timeWindow, tickerType, graphSize) => BubbleGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  //"StackedBar": (context, variable, color, timeWindow, tickerType, graphSize) => StackedBarGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "StackedColumn": (context, variable, color, timeWindow, tickerType, graphSize) => StackedColumnGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "CandleStick": (context, variable, color, timeWindow, tickerType, graphSize) => CandleStickGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
};

Widget getWidget(String widgetType, BuildContext context, dynamic variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize) {
  return widgetRegistry[widgetType]?.call(context, variable, color, timeWindow, tickerType, graphSize) ?? const SizedBox(); // Default to empty if not found
}

List<Widget> getWidgetList(BuildContext context, dynamic variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize) {
  return widgetRegistry.values
      .map((builder) => builder(context, variable, color, timeWindow, tickerType, graphSize))
      .toList();
}

Map<String, dynamic> toJSON(BuildContext context) {
  return widgetRegistry.map((name, builder) {
    final GraphWidget graph = builder(context, {}, Colors.blue, TimeWindow.auto, TickerType.last, GraphSize.half); // ✅ Ensure proper casting
  
    return MapEntry(name, {
      "name": name,
      "builder": builder,
      "allowedSizes":
          graph.allowedSizes.map((e) => e.toString().split('.').last).toList(),
      "allowedVariableTypes": graph.allowedVariableTypes
          .map((e) => e.toString().split('.').last)
          .toList(),
      "allowedVariableForms": graph.allowedVariableForms
          .map((e) => e.toString().split('.').last)
          .toList(),
    });
  });
}