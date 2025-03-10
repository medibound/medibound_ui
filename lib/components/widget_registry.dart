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
    Map<String, dynamic> variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize);

final Map<String, GraphBuilderFunction> widgetRegistry = {
  "Column": (variable, color, timeWindow, tickerType, graphSize) => ColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Line": (variable, color, timeWindow, tickerType, graphSize) => LineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Scatter": (variable, color, timeWindow, tickerType, graphSize) => ScatterGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "StepLine": (variable, color, timeWindow, tickerType, graphSize) => StepLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "FastLine": (variable, color, timeWindow, tickerType, graphSize) => FastLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  //"Histogram": (variable, color, timeWindow, tickerType, graphSize) => HistogramGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "Bubble": (variable, color, timeWindow, tickerType, graphSize) => BubbleGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  //"StackedBar": (variable, color, timeWindow, tickerType, graphSize) => StackedBarGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "StackedColumn": (variable, color, timeWindow, tickerType, graphSize) => StackedColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
  "CandleStick": (variable, color, timeWindow, tickerType, graphSize) => CandleStickGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize),
};

Widget getWidget(String widgetType, dynamic variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize) {
  return widgetRegistry[widgetType]?.call(variable, color, timeWindow, tickerType, graphSize) ?? const SizedBox(); // Default to empty if not found
}

List<Widget> getWidgetList(dynamic variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize) {
  return widgetRegistry.values
      .map((builder) => builder(variable, color, timeWindow, tickerType, graphSize))
      .toList();
}

Map<String, dynamic> toJSON() {
  return widgetRegistry.map((name, builder) {
    final GraphWidget graph = builder({}, Colors.blue, TimeWindow.auto, TickerType.last, GraphSize.half); // ✅ Ensure proper casting
  
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