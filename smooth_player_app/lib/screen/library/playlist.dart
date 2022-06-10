import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/playlist_http.dart';
import 'package:smooth_player_app/api/res/playlist_res.dart';
import 'package:smooth_player_app/screen/library/liked_song.dart';
import 'package:smooth_player_app/screen/library/playlist_song.dart';

import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';

class ViewPlaylist extends StatefulWidget {
  final String? profilePic;
  const ViewPlaylist({Key? key, @required this.profilePic}) : super(key: key);

  @override
  State<ViewPlaylist> createState() => _ViewPlaylistState();
}

class _ViewPlaylistState extends State<ViewPlaylist> {
  final AudioPlayer player = Player.player;
  final profileUrl = ApiUrls.profileUrl;

  late Future<List<Playlist>> userPlaylists;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();
    userPlaylists = PlaylistHttp().viewPlaylists();

    stateSub = player.onPlayerStateChanged.listen((state) {
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
            top: 10,
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            bottom: 80,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Library",
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        NetworkImage(profileUrl + widget.profilePic!),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.remove_circle,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Playlist",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          elevation: 5,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            String title = "";
                            return AlertDialog(
                              title: TextFormField(
                                onChanged: ((value) {
                                  title = value;
                                }),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.form,
                                  hintText: "Enter a title",
                                  enabledBorder: formBorder,
                                  focusedBorder: formBorder,
                                  errorBorder: formBorder,
                                  focusedErrorBorder: formBorder,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.primary,
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (title.trim().isEmpty) {
                                      return;
                                    }
                                    final resData =
                                        await PlaylistHttp().addPlaylist(
                                      title,
                                    );
                                    Navigator.pop(context);

                                    setState(() {
                                      userPlaylists =
                                          PlaylistHttp().viewPlaylists();
                                    });
                                    Fluttertoast.showToast(
                                      msg: resData["resM"],
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                  child: Text("Create"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.primary,
                                    elevation: 10,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
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
                    icon: Icon(
                      Icons.add,
                      color: AppColors.text,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ViewLikedSong(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: const [
                            Color(0XFF36D1DC),
                            Color(0XFF5B86E5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: sWidth * .65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Liked Songs",
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Playlist",
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: AppColors.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Playlist>>(
                  future: userPlaylists,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewPlaylistSong(
                                    playlistId: snapshot.data![index].id,
                                    playlistTitle: snapshot.data![index].title,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 65,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                            )
                                          ],
                                          gradient: LinearGradient(
                                            colors: const [
                                              Color(0XFF36D1DC),
                                              Color(0XFF5B86E5),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Icon(
                                          Icons.music_note_rounded,
                                          size: 35,
                                          color: Colors.white,
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
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                snapshot.data![index].title!,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: AppColors.text,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                "Playlist",
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                  color: AppColors.text,
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
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColors.primary,
                                                  elevation: 10,
                                                  shadowColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        String title = "";
                                                        return AlertDialog(
                                                          title: TextFormField(
                                                            onChanged:
                                                                ((value) {
                                                              title = value;
                                                            }),
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  AppColors
                                                                      .form,
                                                              hintText:
                                                                  "Enter new title",
                                                              enabledBorder:
                                                                  formBorder,
                                                              focusedBorder:
                                                                  formBorder,
                                                              errorBorder:
                                                                  formBorder,
                                                              focusedErrorBorder:
                                                                  formBorder,
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    AppColors
                                                                        .primary,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
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
                                                                if (title
                                                                    .trim()
                                                                    .isEmpty) {
                                                                  return;
                                                                }
                                                                final resData =
                                                                    await PlaylistHttp()
                                                                        .renamePlaylist(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!,
                                                                  title,
                                                                );
                                                                Navigator.pop(
                                                                    context);

                                                                setState(() {
                                                                  userPlaylists =
                                                                      PlaylistHttp()
                                                                          .viewPlaylists();
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: resData[
                                                                      "resM"],
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0,
                                                                );
                                                              },
                                                              child: Text(
                                                                  "Rename"),
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    AppColors
                                                                        .primary,
                                                                elevation: 10,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
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
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Text("Rename"),
                                              ),
                                            ),
                                            SimpleDialogOption(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 75,
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  elevation: 10,
                                                  shadowColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final resData =
                                                      await PlaylistHttp()
                                                          .deletePlaylist(
                                                    snapshot.data![index].id!,
                                                    snapshot
                                                        .data![index].title!,
                                                  );

                                                  setState(() {
                                                    userPlaylists =
                                                        PlaylistHttp()
                                                            .viewPlaylists();
                                                  });

                                                  Fluttertoast.showToast(
                                                    msg: resData["resM"],
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 3,
                                                  );
                                                },
                                                child: Text("Delete"),
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
                  }),
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
      bottomNavigationBar: PageNavigator(pageIndex: 2),
    );
  }
}
