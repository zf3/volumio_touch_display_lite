import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'main.dart';

class BrowserWidget extends StatefulWidget {
  const BrowserWidget({Key? key}) : super(key: key);

  @override
  State<BrowserWidget> createState() => BrowserState();
}

// 取得UTF-8的码点
String enc(String s) {
  if (kIsWeb) {
    List<int> bytes = utf8.encode(s);
    return String.fromCharCodes(bytes);
  } else {
    return s;
  }
}

class BrowserState extends State<BrowserWidget> {
  String uri = defaultDir;

  final ScrollController _scrollController = ScrollController();

  fetchList() {
    debugPrint("Getting uri: $uri");
    if (uri == '/') {
      socket.emit('getBrowseSources');
    } else {
      // Volumio 2.9 expects raw UTF-8 on server side.
      String uri2 = enc(uri);
      var data = {"uri": uri2};
      debugPrint("URI length=${uri2.length}");
      socket.emit("browseLibrary", data);
    }
  }

  void navigate(String toUri) {
    setState(() {
      uri = toUri;
    });
    fetchList();
    _scrollController.jumpTo(0);
  }

  @override
  initState() {
    super.initState();
    fetchList();
  }

  static Icon iconmap(dynamic item) {
    const Icon album = Icon(Icons.album_outlined);
    const Icon computer = Icon(Icons.computer_outlined);
    const Icon artist = Icon(Icons.person);
    const Icon favorite = Icon(Icons.favorite);
    const Icon playlists = Icon(Icons.playlist_play);
    const Icon library = Icon(Icons.music_note);
    const Icon last100 = Icon(Icons.history);
    const Icon radio = Icon(Icons.radio);
    const Icon genres = Icon(Icons.category);
    String uri = item['uri'];
    if (uri.startsWith('favourites')) return favorite;
    if (uri.startsWith('music-library')) return library;
    if (uri.startsWith('playlists')) return playlists;
    if (uri.startsWith('artists://')) return artist;
    if (uri.startsWith('genres')) return genres;
    if (uri.startsWith('upnp')) return computer;
    if (uri.startsWith('Last_100')) return last100;
    if (uri.startsWith('radio')) return radio;
    return album;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build");
    return StreamBuilder<dynamic>(
        stream: browseStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // debugPrint("Browse stream snapshot: $snapshot");
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            dynamic data = snapshot.data;
            var list = [];
            if (data != null) {
              if (data is List) {
                list = data;
              } else {
                list = data['navigation']['lists'];

                // debugPrint('List items: ${list[0]['items']}');
                if (list.isNotEmpty && list[0]['items'] != null) {
                  list = list[0]['items'];
                }
              }
            }

            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                String artUrl = "";
                String? a = list[index]['albumart'];
                if (a != null &&
                    a.contains('cacheid') &&
                    !a.contains('path=&')) {
                  artUrl =
                      "http://$serverAddr:$serverPort${list[index]['albumart']}";
                }

                return InkWell(
                    onTap: () {
                      poke();
                      debugPrint("URI: ${list[index]['uri']}");
                      if (list[index]['type'] == 'song') {
                        // 播放目录下所有歌曲
                        if (kIsWeb) {
                          // Hack: for Web, need to use UTF-8 bytes for all URI
                          for (int i = 0; i < list.length; i++) {
                            if (list[i]['uri'] != null) {
                              list[i]['uri'] = enc(list[i]['uri']);
                            }
                          }
                        }
                        var data = {"list": list, "index": index};
                        socket.emit('replaceAndPlay', data);

                        // 切换到Play页面
                        homeKey.currentState?.showPage(1);

                        // Old: play just one song
                        // List<int> bytes = utf8.encode(list[index]['uri']);
                        // String uri2 = String.fromCharCodes(bytes);
                        // socket.emit('replaceAndPlay', {"uri": uri2});
                      } else {
                        navigate(list[index]['uri']);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 4, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                              height: 32,
                              width: 32,
                              child: Center(
                                child: artUrl == ""
                                    ? iconmap(list[index])
                                    : CachedNetworkImage(
                                        imageUrl: artUrl,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                                Icons.music_note_outlined),
                                      ),
                              )),
                          const SizedBox(width: 8),
                          Text(list[index]['name'] ?? list[index]['title']),
                          const Spacer(),
                        ],
                      ),
                    ));
              },
              itemCount: list.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
