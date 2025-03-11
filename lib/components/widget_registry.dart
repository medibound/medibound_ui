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
    BuildContext context, Map<String, dynamic> variable, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize, double height);

Map<String, dynamic> mockVariable = { 
      "info": {
        "displayName": "Heart Rate",
        "code": "",
        "description": "",
        "color": "",
        "icon": "favorite_rounded"
      },
      "unit": "m",
      "type": "number",
      "is_list": true,
      "data": [
        {
          "number": 35.0,
          "string": "D",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 37)).toIso8601String(),
        },
        {
          "number": 90.0,
          "string": "E",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 45)).toIso8601String(),
        },
        {
          "number": 5.0,
          "string": "A",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 40)).toIso8601String(),
        },
        {
          "number": 15.0,
          "string": "B",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 50)).toIso8601String(),
        },
        {
          "number": 25.0,
          "string": "C",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 55)).toIso8601String(),
        },
        {
          "number": 135.0,
          "string": "D",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 59)).toIso8601String(),
        },
        {
          "number": 45.0,
          "string": "E",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 59)).toIso8601String(),
        },
        {
          "number": 25.0,
          "string": "A",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 50)).toIso8601String(),
        },
        {
          "number": 15.0,
          "string": "B",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 40)).toIso8601String(),
        },
        {
          "number": 25.0,
          "string": "C",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
        },
        {
          "number": 35.0,
          "string": "D",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 20)).toIso8601String(),
        },
        {
          "number": 45.0,
          "string": "E",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 10)).toIso8601String(),
        },
        {
          "number": 45.0,
          "string": "E",
          "timestamp":
              DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
        },
      ],
    };

final Map<String, GraphBuilderFunction> widgetRegistry = {
  "Column": (context, variable, color, timeWindow, tickerType, graphSize, height) => ColumnGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Line": (context, variable, color, timeWindow, tickerType, graphSize, height) => LineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Scatter": (context, variable, color, timeWindow, tickerType, graphSize, height) => ScatterGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "StepLine": (context, variable, color, timeWindow, tickerType, graphSize, height) => StepLineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "FastLine": (context, variable, color, timeWindow, tickerType, graphSize, height) => FastLineGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  //"Histogram": (context, variable, color, timeWindow, tickerType, graphSize, height) => HistogramGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Bubble": (context, variable, color, timeWindow, tickerType, graphSize, height) => BubbleGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  //"StackedBar": (context, variable, color, timeWindow, tickerType, graphSize, height) => StackedBarGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "StackedColumn": (context, variable, color, timeWindow, tickerType, graphSize, height) => StackedColumnGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "CandleStick": (context, variable, color, timeWindow, tickerType, graphSize, height) => CandleStickGraph(context: context, variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
};

Widget getWidget(
  String widgetType,
  BuildContext context,
  Color color,  // ✅ Changed to String // ✅ Changed to String
  String graphSizeStr,   // ✅ Changed to String
  {String timeWindowStr = 'auto', String tickerTypeStr = 'last', double height = 100, dynamic variable}
) {
  variable ??= mockVariable;

  // ✅ Convert Strings to Enums
  TimeWindow? timeWindow = stringToTimeWindow(timeWindowStr);
  TickerType? tickerType = stringToTickerType(tickerTypeStr);
  GraphSize? graphSize = stringToGraphSize(graphSizeStr);

  // ✅ Provide default values if conversion fails
  timeWindow ??= TimeWindow.auto;
  tickerType ??= TickerType.last;
  graphSize ??= GraphSize.half;

  return widgetRegistry[widgetType]?.call(
        context, variable, color, timeWindow, tickerType, graphSize, height) ??
      const SizedBox(); // Default to empty if not found
}

TimeWindow? stringToTimeWindow(String value) {
  try {
    return TimeWindow.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}

TickerType? stringToTickerType(String value) {
  try {
    return TickerType.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}

GraphSize? stringToGraphSize(String value) {
  try {
    return GraphSize.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}


List<Widget> getWidgetList(BuildContext context, Color color, TimeWindow timeWindow, TickerType tickerType, GraphSize graphSize, {double height = 100, dynamic variable = null}) {
  variable ??= mockVariable; 
  
  return widgetRegistry.values
      .map((builder) => builder(context, variable, color, timeWindow, tickerType, graphSize, height))
      .toList();
}


Map<String, dynamic> getWidgetListJson(BuildContext context) {
  return widgetRegistry.map((name, builder) {
    final GraphWidget graph = builder(context, {}, Colors.blue, TimeWindow.auto, TickerType.last, GraphSize.half, 100); // ✅ Ensure proper casting
  
    return MapEntry(name, {
      "name": name,
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