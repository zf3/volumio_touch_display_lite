import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class PlayWidget extends StatefulWidget {
  const PlayWidget({Key? key}) : super(key: key);

  @override
  State<PlayWidget> createState() => PlayState();
}

class PlayState extends State<PlayWidget> {
  Future<dynamic> fetchNowPlaying() async {
    debugPrint("in fetchNowPlaying()");
    final response =
        await http.get(Uri.parse('http://$serverAddr/api/v1/getState'));

    if (response.statusCode == 200) {
      debugPrint("getState response: ${response.body}");
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: fetchNowPlaying(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            dynamic data = snapshot.data;
            String? url = data['albumart'];
            if (url != null) {
              url = "http://$serverAddr$url";
              debugPrint("Play screen album art: $url");
              return Center(child: CachedNetworkImage(imageUrl: url));
            } else {
              return Center(child: Text(data['status']));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
