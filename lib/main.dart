import 'package:flutter/material.dart';
import 'package:medibound_ui/components/inputs/Dropdown.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/medibound_ui.dart';
import './components/graph_types.dart';
import './components/widget_registry.dart';
import './components/inputs/ProfileDropdown.dart';
import './components/utils/Profile.dart';

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
  MBInfo? selectedItem;
  MBProfile? selectedProfile;
  final List<MBInfo> dropdownItems = [
    MBInfo(
      display: "Archimedic",
      description: "Manufacturer",
      code: "archimedic",
    ),
    MBInfo(
      display: "Venture Labs",
      description: "Research and Development",
      code: "venture_labs",
      color: Colors.blue,
      icon: "science",
    ),
    MBInfo(
      display: "Medibound",
      description: "Software Development",
      code: "medibound",
      color: Colors.teal,
      icon: "code",
    ),
    MBInfo(
      display: "BrickSimple",
      description: "Software Development",
      code: "bricksimple",
      color: Colors.red[900]!,
      icon: "architecture",
    ),
    MBInfo(
      display: "Penn Medicine",
      description: "Education",
      code: "penn_medicine",
      color: Colors.indigo[900]!,
      icon: "school",
    ),
  ];

  final List<MBProfile> profiles = [
    MBProfile(
      display: "John Smith",
      description: "Lead Developer",
      photoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgrPoFxnoMhPYStzoBvF2C51CrxYc2vo8-yg&s",
      uid: "user1",
    ),
    MBProfile(
      display: "Sarah Johnson",
      description: "Product Manager",
      photoUrl: "https://i.pravatar.cc/150?img=2",
      uid: "user2",
    ),
    MBProfile(
      display: "Michael Brown",
      description: "UX Designer",
      photoUrl: "https://i.pravatar.cc/150?img=3",
      uid: "user3",
    ),
    MBProfile(
      display: "Emily Davis",
      description: "Software Engineer",
      photoUrl: "https://i.pravatar.cc/150?img=4",
      uid: "user4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //print(Theme.of(context).brightness);

    

    //print(getWidgetListJson());

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              MBDropdown(
                items: dropdownItems,
                selectedItem: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                hintText: "Select an option",
              ),
              MbProfileDropdown(
                items: profiles,
                selectedItem: selectedProfile,
                onChanged: (profile) {
                  setState(() {
                    selectedProfile = profile;
                  });
                },
                hintText: "Select a team member",
                circle: true,
              ),
              const SizedBox(height: 20),
              MbProfileDropdown(
                items: profiles,
                selectedItem: selectedProfile,
                onChanged: (profile) {
                  setState(() {
                    selectedProfile = profile;
                  });
                },
                hintText: "Select a team member (square)",
              ),
              if (selectedProfile != null)
                Text(
                  'Selected: ${selectedProfile!.display} (${selectedProfile!.description})',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              Column(
                spacing: 10,
                children: getWidgetList(Colors.blue,
                    MBTimeWindow.lastHour, MBTickerType.mean,  MBVariableForm.array, MBVariableType.number, MBGraphSize.half, height: 125.0, DateTime.now().subtract(Duration(minutes: 0))),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
