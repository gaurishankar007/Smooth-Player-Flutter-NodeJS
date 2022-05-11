import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/upload_ambum.dart';
import 'package:smooth_player_app/screen/upload_song.dart';

import 'screen/home.dart';

void main() {
  runApp(const SmoothPlayer());
}

class SmoothPlayer extends StatefulWidget {
  const SmoothPlayer({Key? key}) : super(key: key);

  @override
  State<SmoothPlayer> createState() => _SmoothPlayerState();
}

class _SmoothPlayerState extends State<SmoothPlayer> {
  Widget initialPage = Home();
  Widget uploadSongPage = UploadAlbum();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      home: uploadSongPage,
      routes: {
        "/home": (context) => Home(),
        "/uploadSong": (context) => UploadSong(),
        "/uploadAlbum": (context) => UploadAlbum(), 
      },
    );
  }
}