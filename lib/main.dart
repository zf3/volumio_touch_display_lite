// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'browser.dart';
import 'play.dart';
import 'settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:http/http.dart' as http;

const String serverAddr = "192.168.1.96";
const int serverPort = 3000;
const String defaultDir = 'music-library/NAS/DS/2021';

// 没有transport(['websocket'])，在native client下就连不上
Socket socket = io(
    'ws://$serverAddr:$serverPort',
    kIsWeb
        ? OptionBuilder().disableAutoConnect().build()
        : OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

bool landscape = false;

StreamController<dynamic> browseController = StreamController<dynamic>();
Stream<dynamic> browseStream = browseController.stream;
StreamController<dynamic> playController = StreamController<dynamic>();
Stream<dynamic> playStream = playController.stream;

// late Stream perSecond;

void main() async {
  // http.Response r =
  //     await http.get(Uri.parse('http://$serverAddr:$serverPort/api/v1/browse'));
  // debugPrint("${r.statusCode}");
  // debugPrint(r.body);

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
        // fontFamily: 'yahei',
        fontFamily: 'Noto Sans CJK SC',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Digi Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _tabTitle = ['Browse', 'Playing', 'Settings'];

final GlobalKey<BrowserState> _browserKey = GlobalKey(),
    _playKey = GlobalKey(),
    _settingsKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String title = _tabTitle[0];

  _onItemTapped(int index) {
    setState(() {
      title = _tabTitle[index];
      if (index == 0 && _selectedIndex == 0) {
        // When already in browse page, tap the tab once for defaultDir
        // tap twice and more for root (all sources)
        String? uri = _browserKey.currentState?.uri;
        debugPrint(uri);
        String target = (uri == defaultDir || uri == '/') ? '/' : defaultDir;
        _browserKey.currentState?.navigate(target);
      } else if (_selectedIndex == 1) {
        // getState
        socket.emit('getState');
      }
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    debugPrint("Setting up WebSocket");
    socket.on('pushState', (data) {
      debugPrint("WebSocket pushState: $data");
      playController.add(data);
    });
    socket.onConnecting((data) => debugPrint("WebSocket connecting"));
    socket.onConnectTimeout((data) => debugPrint("WebSocket connect timeout."));
    socket.onDisconnect((_) => debugPrint('WebSocket disconnect'));
    socket.onConnect((_) => debugPrint('WebSocket connected'));
    socket.onError((data) => debugPrint("WebSocket error: $data"));
    socket.on("pushBrowseSources", (data) {
      debugPrint("WebSocket pushBrowseSources: $data");
      browseController.add(data);
    });
    socket.on("pushBrowseLibrary", (data) {
      debugPrint("WebSocket pushBrowseLibrary: ");
      debugPrint(data.toString());
      browseController.add(data);
    });

    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    landscape = size.height < size.width;
    debugPrint("main landscape: $landscape");
    _playKey.currentState?.setState(() {});
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: _tabTitle[0], icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: _tabTitle[1], icon: Icon(Icons.play_arrow)),
          BottomNavigationBarItem(
              label: _tabTitle[2], icon: Icon(Icons.settings))
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      body: IndexedStack(children: [
        BrowserWidget(key: _browserKey),
        PlayWidget(key: _playKey),
        SettingsWidget(key: _settingsKey)
      ], index: _selectedIndex),
    );
  }
}
