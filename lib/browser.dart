import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BrowserWidget extends StatefulWidget {
  const BrowserWidget({Key? key}) : super(key: key);

  @override
  State<BrowserWidget> createState() => BrowserState();
}

class BrowserState extends State<BrowserWidget> {
  String uri = '/';

  Future<dynamic> fetchList() async {
    debugPrint("Getting uri: $uri");
    final response = await http
        .get(Uri.parse('http://192.168.1.96/api/v1/browse?uri=$uri'), headers: {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    });

    debugPrint('Response: ${response.body}');
    if (response.statusCode == 200) {
      // debugPrint("Response: $response");
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void home() {
    setState(() {
      uri = '/';
    });
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
    return FutureBuilder<dynamic>(
        future: fetchList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            dynamic data = snapshot.data;
            var list = [];
            if (data != null) {
              list = data['navigation']['lists'];
              // debugPrint('List items: ${list[0]['items']}');
              if (list.isNotEmpty && list[0]['items'] != null) {
                list = list[0]['items'];
              }
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      setState(() {
                        uri = list[index]['uri'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          iconmap(list[index]),
                          const SizedBox(width: 10),
                          Text(list[index]['name'] ?? list[index]['title']),
                          const Spacer(),
                        ],
                      ),
                    ));
              },
              itemCount: list.length,
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
