import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../player.dart';
import 'queue.dart';

class PlayingSong extends StatefulWidget {
  const PlayingSong({Key? key}) : super(key: key);

  @override
  State<PlayingSong> createState() => _PlayingSongState();
}

class _PlayingSongState extends State<PlayingSong> {
  final AudioPlayer player = Player.player;

  late StreamSubscription stateSub, durationSub, positionSub, completionSub;

  int isLoop = Player.isLoop;
  bool isShuffle = Player.isShuffle;

  @override
  void initState() {
    super.initState();

    stateSub = player.onPlayerStateChanged.listen((state) {
      setState(() {
        Player.isPaused = state == PlayerState.PAUSED;
      });
    });

    durationSub = player.onDurationChanged.listen((newDuration) {
      setState(() {
        Player.duration = newDuration;
      });
    });

    positionSub = player.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        Player.position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stateSub.cancel();
    durationSub.cancel();
    positionSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.queue_music_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => SongQueue(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sWidth * .06,
              ),
              child: Container(
                height: sHeight * .6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0XFF36D1DC),
                      Color(0XFF5B86E5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: sWidth * .06,
                    right: sWidth * .06,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: sWidth * .5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Player.playingSong!.title!,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Player.playingSong!.album!.title!,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Slider(
                    min: 0,
                    max: Player.duration.inSeconds.toDouble(),
                    value: Player.position.inSeconds.toDouble(),
                    activeColor: Color(0XFF5B86E5),
                    inactiveColor: Colors.black,
                    onChanged: (value) async {
                      await player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sWidth * .06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Player.duration.toString().split(":")[0] == "0"
                          ? Player.position
                              .toString()
                              .split(".")[0]
                              .substring(2)
                          : Player.position.toString().split(".")[0]),
                      Text(Player.duration.toString().split(":")[0] == "0"
                          ? Player.duration
                              .toString()
                              .split(".")[0]
                              .substring(2)
                          : Player.duration.toString().split(".")[0]),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: sWidth * .06,
                    left: sWidth * .06,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isShuffle
                          ? TextButton(
                              onPressed: () {
                                Player().stopShuffle();
                                setState(() {
                                  isShuffle = Player.isShuffle;
                                });
                              },
                              child: Icon(
                                Icons.shuffle_outlined,
                                size: 40,
                                color: Color(0XFF5B86E5),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                Player().shuffleSong();
                                setState(() {
                                  isShuffle = Player.isShuffle;
                                });
                              },
                              child: Icon(
                                Icons.shuffle_outlined,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Player().previousSong();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Icon(
                              Icons.skip_previous,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                          Player.isPaused
                              ? TextButton(
                                  onPressed: () {
                                    Player().resumeSong();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Icon(
                                    Icons.play_circle_fill_sharp,
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    Player().pauseSong();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Icon(
                                    Icons.pause_circle_filled_rounded,
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                ),
                          TextButton(
                            onPressed: () {
                              Player().nextSong();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Icon(
                              Icons.skip_next,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      isLoop == 0
                          ? TextButton(
                              onPressed: () {
                                Player().singleLoop();
                                setState(() {
                                  isLoop = Player.isLoop;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Icon(
                                Icons.loop_rounded,
                                size: 40,
                                color: Colors.black,
                              ),
                            )
                          : isLoop == 1
                              ? Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Player().multiLoop();
                                        setState(() {
                                          isLoop = Player.isLoop;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Icon(
                                        Icons.loop_rounded,
                                        size: 40,
                                        color: Color(0XFF5B86E5),
                                      ),
                                    ),
                                    Text(
                                      "1",
                                      style: TextStyle(
                                        color: Color(0XFF5B86E5),
                                      ),
                                    )
                                  ],
                                )
                              : TextButton(
                                  onPressed: () {
                                    Player().stopLoop();
                                    setState(() {
                                      isLoop = Player.isLoop;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Icon(
                                    Icons.loop_rounded,
                                    size: 40,
                                    color: Color(0XFF5B86E5),
                                  ),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
