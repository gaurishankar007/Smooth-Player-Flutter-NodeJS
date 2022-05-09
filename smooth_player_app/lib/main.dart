import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      home: initialPage,
      routes: {
        "/home": (context) => Home(),
      },
    );
  }
}