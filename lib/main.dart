import 'package:flutter/material.dart';
import './components/graph_types.dart';
import './components/widget_registry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);

    final Map<String, dynamic> mockVariable = {
      "info": {
        "displayName": "Heart Rate",
        "code": "",
        "description": "",
        "color": "",
        "icon": "favorite_rounded"
      },
      "unit": "m",
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

    print(toJSON(context));

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                spacing: 10,
                children: getWidgetList(context, mockVariable, Colors.blue,
                    TimeWindow.auto, TickerType.std, GraphSize.half),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
