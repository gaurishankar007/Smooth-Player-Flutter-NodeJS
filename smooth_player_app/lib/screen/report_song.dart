import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/report_http.dart';
import 'package:smooth_player_app/resource/report.dart';

import '../resource/colors.dart';
import '../resource/player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';

class ReportSong extends StatefulWidget {
  final String? songId;
  final int? pageIndex;
  const ReportSong({Key? key, @required this.songId, @required this.pageIndex})
      : super(key: key);

  @override
  _ReportSongState createState() => _ReportSongState();
}

class _ReportSongState extends State<ReportSong> {
  final AudioPlayer player = Player.player;
  String reportFor = "Select reports";
  List<String> reportForList = [];

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

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
            color: AppColors.text,
          ),
        ),
        title: Text(
          "Report a Song",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: sWidth * 0.03,
          right: sWidth * 0.03,
          bottom: 80,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.form,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton(
                value: reportFor,
                elevation: 20,
                underline: SizedBox(),
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                ),
                isExpanded: true,
                dropdownColor: AppColors.form,
                borderRadius: BorderRadius.circular(10),
                onChanged: (String? newValue) {
                  setState(() {
                    reportFor = newValue!;
                    if (newValue == "Select reports") {
                      return;
                    } else if (!reportForList.contains(newValue)) {
                      reportForList.add(newValue);
                    }
                  });
                },
                items: ReportFor.reportFor.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: AppColors.text,
                    width: 2,
                  )),
              child: ListView.builder(
                itemCount: reportForList.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          (index + 1).toString() + ".",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          reportForList[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          reportForList.removeAt(index);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (reportForList.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "No report selected.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                final resData = await ReportHttp()
                    .reportSong(widget.songId!, reportForList);

                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: resData["resM"],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              child: Text(
                "Report",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: songBarVisibility
          ? SongBar(
              songData: Player.playingSong,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: PageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
