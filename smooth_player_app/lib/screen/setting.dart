import 'package:flutter/material.dart';
import 'package:smooth_player_app/resource/player.dart';

import '../api/log_status.dart';
import '../resource/colors.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              LogStatus().removeToken();
              LogStatus.token = "";
              Navigator.pushNamedAndRemoveUntil(
                context,
                "login",
                (route) => false,
              );
              Player().stopSong();
            },
            icon: Icon(
              Icons.logout_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 20,
          right: sWidth * .03,
          bottom: 25,
          left: sWidth * .03,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Setting Page"),
          ],
        ),
      ),
    );
  }
}
