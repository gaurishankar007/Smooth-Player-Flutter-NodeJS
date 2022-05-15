import 'package:flutter/material.dart';

import '../../api/log_status.dart';
import '../../colors.dart';
import '../../player.dart';

class AdminSetting extends StatefulWidget {
  const AdminSetting({Key? key}) : super(key: key);

  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
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
              Player().stopSong();
              LogStatus().removeToken();
              LogStatus.token = "";
              Navigator.pushNamedAndRemoveUntil(
                context,
                "login",
                (route) => false,
              );
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
