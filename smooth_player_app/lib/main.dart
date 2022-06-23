import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist.dart';
import 'package:smooth_player_app/screen/authentication/login.dart';
import 'package:smooth_player_app/screen/home.dart';

import 'api/log_status.dart';

void main() {
  WidgetsFlutterBinding();

  LogStatus().getToken().then(
    (value) {
      if (value["token"].isNotEmpty) {
        LogStatus.token = value["token"];
        if (value["admin"]) {
          runApp(const SmoothPlayer(initialPage: FeaturedPlaylistView()));
        } else {
          runApp(const SmoothPlayer(initialPage: Home()));
        }
      } else {
        runApp(const SmoothPlayer(initialPage: Login()));
      }
    },
  );
}

class SmoothPlayer extends StatefulWidget {
  final Widget? initialPage;
  const SmoothPlayer({
    Key? key,
    @required this.initialPage,
  }) : super(key: key);

  @override
  State<SmoothPlayer> createState() => _SmoothPlayerState();
}

class _SmoothPlayerState extends State<SmoothPlayer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      home: widget.initialPage,
    );
  }
}
