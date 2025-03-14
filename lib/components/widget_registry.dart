import 'package:flutter/material.dart';
import 'package:medibound_ui/components/graphs/quarter/RadialGraph.dart';
import '../components/graph_types.dart';
import '../components/graph_widget.dart';
import 'graphs/half/BubbleGraph.dart';
import 'graphs/half/CandleStickGraph.dart';
import 'graphs/half/ColumnGraph.dart';
import 'graphs/half/FastLineGraph.dart';
import 'graphs/half/LineGraph.dart';
import 'graphs/half/ScatterGraph.dart';
import 'graphs/half/StackedColumnGraph.dart';
import 'graphs/half/StepLineGraph.dart';

typedef GraphBuilderFunction = GraphWidget Function(
     Map<String, dynamic> variable, Color color, MBTimeWindow timeWindow, MBTickerType tickerType, MBGraphSize graphSize, double height);

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
  "Column": (variable, color, timeWindow, tickerType, graphSize, height) => ColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Line": (variable, color, timeWindow, tickerType, graphSize, height) => LineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Scatter": (variable, color, timeWindow, tickerType, graphSize, height) => ScatterGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "StepLine": (variable, color, timeWindow, tickerType, graphSize, height) => StepLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "FastLine": (variable, color, timeWindow, tickerType, graphSize, height) => FastLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  //"Histogram": (variable, color, timeWindow, tickerType, graphSize, height) => HistogramGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Bubble": (variable, color, timeWindow, tickerType, graphSize, height) => BubbleGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  //"StackedBar": (variable, color, timeWindow, tickerType, graphSize, height) => StackedBarGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "StackedColumn": (variable, color, timeWindow, tickerType, graphSize, height) => StackedColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "CandleStick": (variable, color, timeWindow, tickerType, graphSize, height) => CandleStickGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
  "Radial": (variable, color, timeWindow, tickerType, graphSize, height) => RadialGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height),
};

Widget getWidget(
  String widgetType,
  Color color,  // ✅ Changed to String // ✅ Changed to String
  String graphSizeStr,   // ✅ Changed to String
  {String timeWindowStr = 'auto', String tickerTypeStr = 'last', double height = 100, dynamic variable}
) {
  variable ??= mockVariable;

  // ✅ Convert Strings to Enums
  MBTimeWindow? timeWindow = stringToTimeWindow(timeWindowStr);
  MBTickerType? tickerType = stringToTickerType(tickerTypeStr);
  MBGraphSize? graphSize = stringToGraphSize(graphSizeStr);

  // ✅ Provide default values if conversion fails
  timeWindow ??= MBTimeWindow.auto;
  tickerType ??= MBTickerType.last;
  graphSize ??= MBGraphSize.half;

  return widgetRegistry[widgetType]?.call(
        variable, color, timeWindow, tickerType, graphSize, height) ??
      const SizedBox(); // Default to empty if not found
}

MBTimeWindow? stringToTimeWindow(String value) {
  try {
    return MBTimeWindow.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}

MBTickerType? stringToTickerType(String value) {
  try {
    return MBTickerType.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}

MBGraphSize? stringToGraphSize(String value) {
  try {
    return MBGraphSize.values.firstWhere((e) => e.name == value);
  } catch (e) {
    return null;
  }
}


List<Widget> getWidgetList(
  Color color,
  MBTimeWindow timeWindow,
  MBTickerType tickerType,
  MBGraphSize graphSize, {
  double height = 100,
  dynamic variable,
}) {
  variable ??= mockVariable;

  return widgetRegistry.values
      .where((builder) {
        final GraphWidget graph = builder(variable, color, timeWindow, tickerType, graphSize, height);
        return graph.allowedSizes.contains(graphSize); // ✅ Filter by size first
      })
      .map((builder) => builder(variable, color, timeWindow, tickerType, graphSize, height))
      .toList();
}


Map<String, dynamic> getWidgetListJson() {
  return widgetRegistry.map((name, builder) {
    final GraphWidget graph = builder({}, Colors.blue, MBTimeWindow.auto, MBTickerType.last, MBGraphSize.half, 100); // ✅ Ensure proper casting
  
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