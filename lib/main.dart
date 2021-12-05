// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'browser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digi Player',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Digi Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

final _tabTitle = ['Browse', 'Playing', 'Settings'];

final GlobalKey<BrowserState> _myKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String title = _tabTitle[0];
  final BrowserWidget _browser = BrowserWidget(key: _myKey);

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      title = _tabTitle[index];
      if (_selectedIndex == 0) {
        _myKey.currentState?.home();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  label: _tabTitle[0], icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: _tabTitle[1], icon: Icon(Icons.play_arrow)),
              BottomNavigationBarItem(
                  label: _tabTitle[2], icon: Icon(Icons.settings))
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          body: Center(
            child: _browser,
          ),
        ));
  }
}
