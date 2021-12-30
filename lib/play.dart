import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'main.dart';

// Once per second
Stream<int> progressStream =
    Stream.periodic(const Duration(seconds: 1), (int x) {
  return x;
}).asBroadcastStream();

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
              url = "http://$serverAddr:$serverPort$url";
              debugPrint("Play screen album art: $url");
              pushSeek = data['seek'] ?? 0;
              pushDuration = data['duration'];
              pushTimestamp = DateTime.now().millisecondsSinceEpoch;
              playing = data['status'] == 'play';
              progress = pushSeek / 1000.0 / pushDuration;
              if (progress.isNaN) progress = 0.0;
              debugPrint(
                  "Progress: seek=$pushSeek, duration=$pushDuration, playing=$playing, progress=$progress");
              bool darkMode = appKey.currentState!.darkMode;
              Color btnColor = darkMode
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 100, 100, 100);

              // Navigation stuff
              var navs = [
                Text(data['title'], style: const TextStyle(fontSize: 20.0)),
                const SizedBox(height: 10),
                Text(data['artist']),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: StreamBuilder(
                      stream: progressStream,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (playing) {
                          // update progress
                          int passed = DateTime.now().millisecondsSinceEpoch -
                              pushTimestamp;
                          progress =
                              (pushSeek + passed) / 1000.0 / pushDuration;
                          //  Keep screen on when playing
                          poke();
                        }
                        return LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          value: progress,
                        );
                      },
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          data['repeatSingle'] == true
                              ? Icons.repeat_one_on_rounded
                              : (data['repeat'] == true
                                  ? Icons.repeat_on_rounded
                                  : Icons.repeat_rounded),
                          color: btnColor,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          // self.commandRouter.volumioRepeat(data.value, data.repeatSingle);
                          var v = {};
                          // no repeat -> repeat all -> repeat single
                          if (data['repeat'] == false) {
                            v['value'] = true;
                            v['repeatSingle'] = false;
                          } else {
                            if (data['repeatSingle'] == false) {
                              v['value'] = true;
                              v['repeatSingle'] = true;
                            } else {
                              v['value'] = false;
                              v['repeatSingle'] = false;
                            }
                          }
                          socket.emit('setRepeat', v);
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: btnColor,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        socket.emit('prev');
                      },
                    ),
                    data['status'] != 'play'
                        ? IconButton(
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              color: btnColor,
                            ),
                            iconSize: 50,
                            onPressed: () {
                              socket.emit("toggle");
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.pause_rounded,
                              color: btnColor,
                            ),
                            iconSize: 50,
                            onPressed: () {
                              socket.emit("pause");
                            }),
                    IconButton(
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: btnColor,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          socket.emit('next');
                        }),
                    IconButton(
                        icon: Icon(
                          data['random'] == true
                              ? Icons.shuffle_on_rounded
                              : Icons.shuffle_rounded,
                          color: btnColor,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          socket.emit('setRandom',
                              {"value": data['random'] == true ? false : true});
                        }),
                  ],
                )
              ];

              debugPrint("landscape: $landscape");
              if (landscape) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: CachedNetworkImage(imageUrl: url)),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: navs))
                    ]);
              } else {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                              Expanded(
                                  child: CachedNetworkImage(
                                      imageUrl: url, fit: BoxFit.fitWidth)),
                              const SizedBox(height: 10),
                            ] +
                            navs));
              }
            } else {
              return Center(child: Text(data['status']));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
