import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/screen/authentication/login.dart';
import 'package:smooth_player_app/screen/authentication/sign_up.dart';
import 'package:smooth_player_app/screen/home.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      initialRoute: 'login',
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignupPage(),
        "home": (context) => Home(),
      },
    );
  }
}
