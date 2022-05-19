import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/urls.dart';

import '../api/res/song_res.dart';
import '../player.dart';
import '../screen/music/playing.dart';

class SongBar extends StatefulWidget {
  final Song? songData;
  const SongBar({Key? key, @required this.songData}) : super(key: key);

  @override
  State<SongBar> createState() => _SongBarState();
}

class _SongBarState extends State<SongBar> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;

  late StreamSubscription stateSub, completionSub;
  late Song? songData;

  @override
  void initState() {
    super.initState();

    songData = widget.songData;

    stateSub = player.onPlayerStateChanged.listen((state) {
      setState(() {
        Player.isPaused = state == PlayerState.PAUSED;
        songData = Player.playingSong;
      });
    });

    completionSub = player.onPlayerCompletion.listen((state) {
      // Player().autoNextSong();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stateSub.cancel();
    completionSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => PlayingSong(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(4),
          height: 60,
          decoration: BoxDecoration(
            color: Color(0XFF5B86E5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, -5),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          coverImage + Player.playingSong!.cover_image!,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: sWidth * .45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            songData!.title!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            songData!.album!.artist!.profile_name!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Player().previousSong();
                      // setState(() {
                      //   songData = Player.playingSong;
                      // });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Icon(
                      Icons.skip_previous,
                      size: 35,
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Icon(
                            Icons.play_arrow_sharp,
                            size: 40,
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Icon(
                            Icons.pause_sharp,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                  TextButton(
                    onPressed: () {
                      // Player().nextSong();
                      // setState(() {
                      //   songData = Player.playingSong;
                      // });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Icon(
                      Icons.skip_next,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
