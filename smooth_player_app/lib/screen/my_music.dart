import 'package:flutter/material.dart';

import '../widget/navigator.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({Key? key}) : super(key: key);

  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("My music Page"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 3),
    );
  }
}
