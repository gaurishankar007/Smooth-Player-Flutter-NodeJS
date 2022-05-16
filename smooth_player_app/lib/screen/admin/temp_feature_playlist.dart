import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/admin/upload_playlist.dart';
import 'package:smooth_player_app/widget/admin_navigator.dart';

import '../../colors.dart';
import '../../player.dart';
import '../../widget/song_bar.dart';
import '../setting.dart';

class FeaturedPlaylist extends StatefulWidget {
  const FeaturedPlaylist({Key? key}) : super(key: key);

  @override
  State<FeaturedPlaylist> createState() => _FeaturedPlaylistState();
}

class _FeaturedPlaylistState extends State<FeaturedPlaylist> {
  final AudioPlayer player = Player.player;
  int curTime = DateTime.now().hour;
  String greeting = "Smooth Player";

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();
    if (5 <= curTime && 12 >= curTime) {
      greeting = "Good Morning";
    } else if (12 <= curTime && 18 >= curTime) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.settings,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => Setting(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text("Featured Playlist"),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder) => UploadPlaylist()));
              }, child: Text("Create Playlist")),
            ],
          ),
        ),
      ),
      floatingActionButton: songBarVisibility
          ? SongBar(
              songData: Player.playingSong,
            )
          : null,
      bottomNavigationBar: AdminPageNavigator(pageIndex: 0),
    );
  }
}


