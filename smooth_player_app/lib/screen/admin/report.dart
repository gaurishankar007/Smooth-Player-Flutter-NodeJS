import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/featured_playlist_http.dart';
import 'package:smooth_player_app/api/http/report_http.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/api/res/report_res.dart';
import 'package:smooth_player_app/screen/admin/create_featured_playlist.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist_song.dart';
import 'package:smooth_player_app/widget/admin_navigator.dart';

import '../../api/res/song_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/song_bar.dart';
import 'artist_profile.dart';

class ReportedSongs extends StatefulWidget {
  const ReportedSongs({Key? key}) : super(key: key);

  @override
  State<ReportedSongs> createState() => _ReportedSongsState();
}

class _ReportedSongsState extends State<ReportedSongs> {
  final AudioPlayer player = Player.player;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;
  final profileUrl = ApiUrls.profileUrl;
  final coverImageUrl = ApiUrls.coverImageUrl;

  bool more = true;
  int reportNum = 10;
  late int reportLength;
  late Future<List<Report>> reports;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  Future<List<Report>> featuredPlaylistView() async {
    List<Report> resData = await ReportHttp().viewAllReports(reportNum);
    reportLength = resData.length;
    return resData;
  }

  @override
  void initState() {
    super.initState();
    reports = featuredPlaylistView();

    stateSub = player.onAudioPositionChanged.listen((state) {
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

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            top: 10,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      onChanged: ((value) {
                        if (value.trim().isEmpty) {
                          setState(() {
                            more = true;
                            reports = ReportHttp().viewAllReports(reportNum);
                          });
                        } else {
                          setState(() {
                            more = false;
                            reports = ReportHttp().searchReports(value);
                          });
                        }
                      }),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.form,
                        hintText: "Search artist reports",
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<Report>>(
                future: reports,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.text,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 1,
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              GestureDetector(
                                onDoubleTap: () {
                                  Song newSong = Song(
                                    id: snapshot.data![index].song!.id!,
                                    title: snapshot.data![index].song!.title!,
                                    album: snapshot.data![index].song!.album!,
                                    music_file:
                                        snapshot.data![index].song!.music_file!,
                                    cover_image: snapshot
                                        .data![index].song!.cover_image!,
                                    like: snapshot.data![index].song!.like!,
                                  );

                                  Player().playSong(newSong, [newSong]);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              )
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                coverImageUrl +
                                                    snapshot.data![index].song!
                                                        .cover_image!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: sWidth * .65,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: snapshot.data![index]
                                                            .song!.title! +
                                                        " (",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.text,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot
                                                                .data![index]
                                                                .song!
                                                                .album!
                                                                .title! +
                                                            ")",
                                                        style: TextStyle(
                                                          color: AppColors.text,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            ArtistPage(
                                                          artistId: snapshot
                                                              .data![index]
                                                              .song!
                                                              .album!
                                                              .artist!
                                                              .id,
                                                          pageIndex: 2,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    snapshot
                                                        .data![index]
                                                        .song!
                                                        .album!
                                                        .artist!
                                                        .profile_name!,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      color: AppColors.text,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => SimpleDialog(
                                            children: [
                                              SimpleDialogOption(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 75,
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: AppColors.primary,
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await ReportHttp()
                                                        .deleteReport(snapshot
                                                            .data![index].id!);
                                                    Navigator.of(ctx).pop();
                                                    setState(() {
                                                      reports = ReportHttp()
                                                          .viewAllReports(
                                                              reportNum);
                                                    });
                                                  },
                                                  child: Text("Delete Report"),
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 75,
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                        title: Text("Delete " +
                                                            snapshot
                                                                .data![index]
                                                                .song!
                                                                .title!),
                                                        content: Text(
                                                            "Are you sure you want to delete this reported song."),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.red,
                                                              elevation: 10,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await ReportHttp()
                                                                  .deleteReportedSong(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .song!
                                                                          .id!);
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: snapshot
                                                                        .data![
                                                                            index]
                                                                        .song!
                                                                        .title! +
                                                                    " song has been deleted",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    3,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0,
                                                              );
                                                              setState(() {
                                                                reports =
                                                                    ReportHttp()
                                                                        .viewMyReports();
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("Yes"),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: AppColors
                                                                  .primary,
                                                              elevation: 10,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("No"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Text("Delete Song"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.more_vert,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data![index].reportFor!.length,
                                itemBuilder: (context, index1) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.report_outlined,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: sWidth * .75,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              snapshot.data![index]
                                                  .reportFor![index1],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          profileUrl +
                                              snapshot.data![index].user!
                                                  .profile_picture!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: sWidth * .6,
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Reporter: ",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: snapshot.data![index].user!
                                                .profile_name,
                                            style: TextStyle(
                                              color: AppColors.text,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              snapshot.data![index].message!.isNotEmpty
                                  ? SizedBox(
                                      height: 5,
                                    )
                                  : SizedBox(),
                              snapshot.data![index].message!.isNotEmpty
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: sWidth * .75,
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Warning: ",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: snapshot
                                                      .data![index].message!,
                                                  style: TextStyle(
                                                    color: AppColors.text,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  String message = "";
                                                  return AlertDialog(
                                                    title: TextFormField(
                                                      onChanged: ((value) {
                                                        message = value;
                                                      }),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            AppColors.form,
                                                        hintText:
                                                            "Enter new warning message",
                                                        enabledBorder:
                                                            formBorder,
                                                        focusedBorder:
                                                            formBorder,
                                                        errorBorder: formBorder,
                                                        focusedErrorBorder:
                                                            formBorder,
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              AppColors.primary,
                                                          elevation: 10,
                                                          shadowColor:
                                                              Colors.black,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          if (message
                                                              .trim()
                                                              .isEmpty) {
                                                            return;
                                                          }
                                                          final resData =
                                                              await ReportHttp()
                                                                  .warnArtist(
                                                            snapshot
                                                                .data![index]
                                                                .id!,
                                                            message,
                                                          );
                                                          Navigator.pop(
                                                              context);

                                                          setState(() {
                                                            reports = ReportHttp()
                                                                .viewAllReports(
                                                                    reportNum);
                                                          });
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                resData["resM"],
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                3,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0,
                                                          );
                                                        },
                                                        child: Text("Submit"),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              AppColors.primary,
                                                          elevation: 10,
                                                          shadowColor:
                                                              Colors.black,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            padding: EdgeInsets.all(5),
                                            minimumSize: Size.zero,
                                            elevation: 10,
                                            shadowColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              String message = "";
                                              return AlertDialog(
                                                title: TextFormField(
                                                  onChanged: ((value) {
                                                    message = value;
                                                  }),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: AppColors.form,
                                                    hintText:
                                                        "Enter a warning message",
                                                    enabledBorder: formBorder,
                                                    focusedBorder: formBorder,
                                                    errorBorder: formBorder,
                                                    focusedErrorBorder:
                                                        formBorder,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          AppColors.primary,
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if (message
                                                          .trim()
                                                          .isEmpty) {
                                                        return;
                                                      }
                                                      final resData =
                                                          await ReportHttp()
                                                              .warnArtist(
                                                        snapshot
                                                            .data![index].id!,
                                                        message,
                                                      );
                                                      Navigator.pop(context);

                                                      setState(() {
                                                        reports = ReportHttp()
                                                            .viewAllReports(
                                                                reportNum);
                                                      });
                                                      Fluttertoast.showToast(
                                                        msg: resData["resM"],
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    },
                                                    child: Text("Submit"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          AppColors.primary,
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.primary,
                                        padding: EdgeInsets.all(8),
                                        minimumSize: Size.zero,
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text("Warn Artist"),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "${snapshot.error}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
              more
                  ? OutlinedButton(
                      onPressed: () async {
                        final resData =
                            await ReportHttp().viewAllReports(reportNum + 10);
                        if (resData.length == reportLength) {
                          setState(() {
                            more = false;
                          });
                          return;
                        } else {
                          reportNum = reportNum + 10;
                          reportLength = resData.length;
                          setState(() {
                            reports = ReportHttp().viewAllReports(reportNum);
                          });
                        }
                      },
                      child: Text(
                        "More",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        primary: AppColors.primary,
                        side: BorderSide(
                          width: 2,
                          color: AppColors.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: songBarVisibility
          ? SongBar(
              songData: Player.playingSong,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: AdminPageNavigator(
        pageIndex: 2,
      ),
    );
  }
}
