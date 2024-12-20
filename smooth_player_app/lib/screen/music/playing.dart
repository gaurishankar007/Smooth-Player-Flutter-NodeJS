import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/like_http.dart';
import 'package:smooth_player_app/resource/colors.dart';

import '../../api/urls.dart';
import '../../resource/player.dart';
import 'queue.dart';

class PlayingSong extends StatefulWidget {
  const PlayingSong({Key? key}) : super(key: key);

  @override
  State<PlayingSong> createState() => _PlayingSongState();
}

class _PlayingSongState extends State<PlayingSong> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;

  late StreamSubscription stateSub, durationSub, positionSub, completionSub;

  int isLoop = Player.isLoop;
  bool isShuffle = Player.isShuffle;
  bool songLike = false;

  void checkSongLike() async {
    if (Player.playingSong != null) {
      songLike = await LikeHttp().checkSongLike(Player.playingSong!.id!);
    }
  }

  @override
  void initState() {
    super.initState();

    checkSongLike();

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
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  Player.playingSong!.album!.title!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.queue_music_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
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
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    height: sHeight * .6,
                    width: sWidth * .94,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      coverImage + Player.playingSong!.cover_image!,
                    ),
                  ),
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
                        width: sWidth * .7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                Player.playingSong!.title!,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                Player
                                    .playingSong!.album!.artist!.profile_name!,
                                style: TextStyle(
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (Player.playingSong != null) {
                            final resData = await LikeHttp().likeSong(
                              Player.playingSong!.id!,
                              Player.playingSong!.title!,
                            );

                            if (resData["statusCode"] == 200) {
                              setState(() {
                                songLike = !songLike;
                              });
                              Fluttertoast.showToast(
                                msg: resData["body"]["resM"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: resData["body"]["resM"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 25,
                          color: songLike ? AppColors.primary : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
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
                                size: 30,
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
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Player().previousSong();
                              setState(() {
                                checkSongLike();
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Icon(
                              Icons.skip_previous,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Player.isPaused
                              ? GestureDetector(
                                  onTap: () {
                                    Player().resumeSong();
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: const [
                                              Color(0XFF36D1DC),
                                              Color(0XFF5B86E5),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Player().pauseSong();
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: const [
                                              Color(0XFF36D1DC),
                                              Color(0XFF5B86E5),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                      Icon(
                                        Icons.pause,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Player().nextSong();
                              setState(() {
                                checkSongLike();
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Icon(
                              Icons.skip_next,
                              size: 40,
                              color: AppColors.primary,
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
                              child: Icon(
                                Icons.loop_rounded,
                                size: 30,
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
                                      child: Icon(
                                        Icons.loop_rounded,
                                        size: 30,
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
                                  child: Icon(
                                    Icons.loop_rounded,
                                    size: 30,
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
