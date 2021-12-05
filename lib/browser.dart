import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BrowserWidget extends StatelessWidget {
  final String uri = '/';

  const BrowserWidget({Key? key}) : super(key: key);

  Future<dynamic> fetchList() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:3000/api/v1/browse?uri=$uri'),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*"
        });

    // log('got response');
    // debugPrint('Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      // debugPrint("Response: $response");
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
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
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 16, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      iconmap(list[index]),
                      const SizedBox(width: 10),
                      Text(list[index]['name']),
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

  //   return ListView(children: <Widget>[
  //     Container(
  //       height: 50,
  //       color: Colors.amber[600],
  //       child: const Center(child: Text('Entry A')),
  //     ),
  //     Container(
  //       height: 50,
  //       color: Colors.amber[500],
  //       child: const Center(child: Text('Entry B')),
  //     ),
  //     Container(
  //       height: 50,
  //       color: Colors.amber[100],
  //       child: const Center(child: Text('Entry C')),
  //     ),
  //   ]);
  // }
}
