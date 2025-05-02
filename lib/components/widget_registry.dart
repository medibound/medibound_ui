import 'package:flutter/material.dart';
import 'package:medibound_ui/components/graphs/number/quarter/FullRadialGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/LinearGaugeGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/NumberGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/NumberSplitGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/RadialGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/RadialHorizontalGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/RadialIconGraph.dart';
import 'package:medibound_ui/components/graphs/number/quarter/ChecklistProgressGauge.dart';
import 'package:medibound_ui/components/graphs/number/half/ECGGraph.dart';
import 'package:medibound_ui/components/graphs/string/LabelGraph.dart';
import 'package:medibound_ui/components/graphs/string/LabelModeGraph.dart';
import 'utils/ComponentTypes.dart';
import '../components/graph_widget.dart';
import 'graphs/number/half/BubbleGraph.dart';
import 'graphs/number/half/CandleStickGraph.dart';
import 'graphs/number/half/ColumnGraph.dart';
import 'graphs/number/half/FastLineGraph.dart';
import 'graphs/number/half/LineGraph.dart';
import 'graphs/number/half/ScatterGraph.dart';
import 'graphs/number/half/StackedColumnGraph.dart';
import 'graphs/number/half/StepLineGraph.dart';

typedef GraphBuilderFunction = GraphWidget Function(
     Map<String, dynamic> variable, Color color, MBTimeWindow timeWindow, MBTickerType tickerType, MBGraphSize graphSize, double height, DateTime referenceTime);

Map<String, dynamic> mockVariable = { 
      "info": {
        "display": "Heart Rate",
        "code": "",
        "description": "",
        "color": "",
        "icon": "favorite_rounded"
      },
      "unit": "bpm",
      "type": "number",
      "is_list": true,
      /*"range": {
        "lower_bound": 0,
        "upper_bound": 50,
      },*/
      "data": [
        {"number": 0.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 0)).toIso8601String()},
    {"number": 15.7, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 3)).toIso8601String()},
    {"number": 30.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 6)).toIso8601String()},
    {"number": 41.4, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 9)).toIso8601String()},
    {"number": 48.2, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 12)).toIso8601String()},
    {"number": 49.9, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 15)).toIso8601String()},
    {"number": 46.5, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 18)).toIso8601String()},
    {"number": 38.3, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 21)).toIso8601String()},
    {"number": 26.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 24)).toIso8601String()},
    {"number": 11.1, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 27)).toIso8601String()},
    {"number": -5.5, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 30)).toIso8601String()},
    {"number": -20.7, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 33)).toIso8601String()},
    {"number": -33.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 36)).toIso8601String()},
    {"number": -41.4, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 39)).toIso8601String()},
    {"number": -45.8, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 42)).toIso8601String()},
    {"number": -45.8, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 45)).toIso8601String()},
    {"number": -41.4, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 48)).toIso8601String()},
    {"number": -33.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 51)).toIso8601String()},
    {"number": -20.7, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 54)).toIso8601String()},
        {"number": 26.0, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 24)).toIso8601String()},

    {"number": -5.5, "string": "Sine Wave", "timestamp": DateTime.now().subtract(Duration(minutes: 57)).toIso8601String()},
      ],
    };

final Map<String, GraphBuilderFunction> widgetRegistry = {
  "Column": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => ColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "Line": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => LineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "Scatter": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => ScatterGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "StepLine": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => StepLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "FastLine": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => FastLineGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  //"Histogram": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => HistogramGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "Bubble": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => BubbleGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  //"StackedBar": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => StackedBarGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "StackedColumn": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => StackedColumnGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "CandleStick": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => CandleStickGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "Radial": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => RadialGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "RadialHorizontal": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => RadialHorizontalGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "RadialIcon": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => RadialIconGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "LinearGuage": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => LinearGaugeGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "NumberSplit": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => NumberSplitGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "Number": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => NumberGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "FullRadial": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => FullRadialGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "LabelGraph": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => LabelGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "LabelModeGraph": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => LabelModeGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  
  // Medical Device Visualizations
  "ECG": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => ECGGraph(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
  "ChecklistProgress": (variable, color, timeWindow, tickerType, graphSize, height, referenceTime) => ChecklistProgressGauge(variable: variable, color: color, timeWindow: timeWindow, tickerType: tickerType, graphSize: graphSize, height: height, referenceTime: referenceTime),
};

Widget getWidget(
  String widgetType,
  Color color,  // ✅ Changed to String // ✅ Changed to String
  String graphSizeStr,
  DateTime referenceTime,   // ✅ Changed to String
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
        variable, color, timeWindow, tickerType, graphSize, height, referenceTime) ??
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
  MBVariableForm variableForm,
  MBVariableType variableType,
  MBGraphSize graphSize,DateTime referenceTime, {
  double height = 100,
  dynamic variable,
  
}) {
  variable ??= mockVariable;

  return widgetRegistry.values
      .where((builder) {
        final GraphWidget graph = builder(variable, color, timeWindow, tickerType, graphSize, height, referenceTime);
        return graph.allowedSizes.contains(graphSize) && graph.allowedVariableForms.contains(variableForm) && graph.allowedVariableTypes.contains(variableType); // ✅ Filter by size first
      })
      .map((builder) => builder(variable, color, timeWindow, tickerType, graphSize, height, referenceTime))
      .toList();
}


Map<String, dynamic> getWidgetListJson() {
  return widgetRegistry.map((name, builder) {
    final GraphWidget graph = builder({}, Colors.blue, MBTimeWindow.auto, MBTickerType.last, MBGraphSize.half, 100, DateTime.now()); // ✅ Ensure proper casting
  
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