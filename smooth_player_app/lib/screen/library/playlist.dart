import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/library/liked_song.dart';

import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';

class ViewPlaylist extends StatefulWidget {
  final String? profilePic;
  const ViewPlaylist({Key? key, @required this.profilePic}) : super(key: key);

  @override
  State<ViewPlaylist> createState() => _ViewPlaylistState();
}

class _ViewPlaylistState extends State<ViewPlaylist> {
  final AudioPlayer player = Player.player;
  final profileUrl = ApiUrls.profileUrl;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;
  int libraryIndex = 0;

  @override
  void initState() {
    super.initState();
    stateSub = player.onPlayerStateChanged.listen((state) {
      setState(() {
        songBarVisibility = Player.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stateSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            left: sWidth * 0.03,
            right: sWidth * 0.03,
          ),
          child: Column(
            children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Library",
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                                profileUrl + widget.profilePic!),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.remove_circle,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Playlist",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          elevation: 5,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: AppColors.text,
                      size: 35,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ViewLikedSong(),
                    ),
                  );
                },
                child: Text("Liked Song"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: songBarVisibility
          ? SongBar(
              songData: Player.playingSong,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: PageNavigator(pageIndex: 2),
    );
  }
}
