import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist.dart';
import 'package:smooth_player_app/screen/authentication/login.dart';
import 'package:smooth_player_app/screen/authentication/sign_up.dart';
import 'package:smooth_player_app/screen/home.dart';
import 'package:smooth_player_app/screen/upload/edit_song.dart';

import 'api/log_status.dart';

void main() {
  runApp(const SmoothPlayer());
}

class SmoothPlayer extends StatefulWidget {
  const SmoothPlayer({Key? key}) : super(key: key);

  @override
  State<SmoothPlayer> createState() => _SmoothPlayerState();
}

class _SmoothPlayerState extends State<SmoothPlayer> {
  Widget initialPage = Login();
  Widget editsong = EditSong();

  @override
  void initState() {
    super.initState();

    LogStatus().getToken().then(
      (value) {
        if (value["token"].isNotEmpty) {
          LogStatus.token = value["token"];
          if (value["admin"]) {
            setState(() {
              initialPage = FeaturedPlaylist();
            });
          } else {
            setState(() {
              initialPage = Home();
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      home: editsong,
      routes: {
        "login": (context) => Login(),
        "signUp": (context) => SignUp(),
        "home": (context) => Home(),
      },
    );
  }
}
