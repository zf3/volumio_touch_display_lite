import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'main.dart';

// Once per second
Stream<int> progressStream =
    Stream.periodic(const Duration(seconds: 1), (int x) {
  return x;
});

class PlayWidget extends StatefulWidget {
  const PlayWidget({Key? key}) : super(key: key);

  @override
  State<PlayWidget> createState() => PlayState();
}

class PlayState extends State<PlayWidget> {
  int pushSeek = 0;
  int pushDuration = 0;
  int pushTimestamp = 0;
  bool playing = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: playStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            dynamic data = snapshot.data;
            String? url = data['albumart'];
            if (url != null) {
              url = "http://$serverAddr$url";
              // debugPrint("Play screen album art: $url");
              pushSeek = data['seek'];
              pushDuration = data['duration'];
              pushTimestamp = DateTime.now().millisecondsSinceEpoch;
              playing = data['status'] == 'play';
              progress = pushSeek / 1000.0 / pushDuration;
              if (progress.isNaN) progress = 0.0;
              debugPrint(
                  "Progress: seek=$pushSeek, duration=$pushDuration, playing=$playing, progress=$progress");

              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    CachedNetworkImage(imageUrl: url),
                    const SizedBox(height: 10),
                    Text(data['title'], style: const TextStyle(fontSize: 20.0)),
                    const SizedBox(height: 10),
                    Text(data['artist']),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: StreamBuilder(
                          stream: progressStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (playing) {
                              // update progress
                              int passed =
                                  DateTime.now().millisecondsSinceEpoch -
                                      pushTimestamp;
                              progress =
                                  (pushSeek + passed) / 1000.0 / pushDuration;
                            }
                            return LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.blue),
                              value: progress,
                            );
                          },
                        )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Color.fromARGB(255, 100, 100, 100),
                          ),
                          iconSize: 50,
                          onPressed: () {
                            socket.emit('prev');
                          },
                        ),
                        const SizedBox(width: 20),
                        data['status'] != 'play'
                            ? IconButton(
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                ),
                                iconSize: 50,
                                onPressed: () {
                                  socket.emit("toggle");
                                },
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.pause_rounded,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                ),
                                iconSize: 50,
                                onPressed: () {
                                  socket.emit("pause");
                                }),
                        const SizedBox(width: 20),
                        IconButton(
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Color.fromARGB(255, 100, 100, 100),
                            ),
                            iconSize: 50,
                            onPressed: () {
                              socket.emit('next');
                            }),
                      ],
                    )
                  ]));
            } else {
              return Center(child: Text(data['status']));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
