import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/featured_playlist_http.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/screen/admin/create_featured_playlist.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist_song.dart';
import 'package:smooth_player_app/screen/authentication/login.dart';
import 'package:smooth_player_app/widget/admin_navigator.dart';

import '../../api/log_status.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/song_bar.dart';

class FeaturedPlaylistView extends StatefulWidget {
  const FeaturedPlaylistView({Key? key}) : super(key: key);

  @override
  State<FeaturedPlaylistView> createState() => _FeaturedPlaylistViewState();
}

class _FeaturedPlaylistViewState extends State<FeaturedPlaylistView> {
  final AudioPlayer player = Player.player;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;
  int curTime = DateTime.now().hour;
  String greeting = "Smooth Player";

  bool more = true;
  int featuredPlaylistNum = 10;
  late Future<List<FeaturedPlaylist>> featuredPlaylists;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();
    if (5 <= curTime && 12 >= curTime) {
      greeting = "Good Morning";
    } else if (12 <= curTime && 18 >= curTime) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    featuredPlaylists =
        FeaturedPlaylistHttp().getFeaturedPlaylist(featuredPlaylistNum);

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
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sWidth * 0.03,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.logout,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            LogStatus().removeToken();
                            LogStatus.token = "";
                            LogStatus.admin = false;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => Login(),
                              ),
                              (route) => false,
                            );
                            Player().stopSong();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: sWidth * .75,
                          height: 50,
                          child: TextFormField(
                            onChanged: ((value) {
                              if (value.trim().isEmpty) {
                                setState(() {
                                  more = true;
                                  featuredPlaylists = FeaturedPlaylistHttp()
                                      .getFeaturedPlaylist(featuredPlaylistNum);
                                });
                              } else {
                                setState(() {
                                  more = false;
                                  featuredPlaylists = FeaturedPlaylistHttp()
                                      .searchPlaylist(value);
                                });
                              }
                            }),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.form,
                              hintText: "Search Playlist",
                              enabledBorder: formBorder,
                              focusedBorder: formBorder,
                              errorBorder: formBorder,
                              focusedErrorBorder: formBorder,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.all(4.0),
                              primary: AppColors.primary,
                              elevation: 10,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateFeaturedPlaylist()));
                            },
                            child: Icon(
                              Icons.add,
                              size: 25,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<FeaturedPlaylist>>(
                future: featuredPlaylists,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      padding: EdgeInsets.only(
                        top: sHeight * .01,
                        left: sWidth * .03,
                        right: sWidth * .03,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio:
                          (sWidth - (sWidth * .55)) / (sHeight * .25),
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(snapshot.data![index].title!),
                                  content: Text(
                                      "Are you sure you want to delete this featured playlist ?"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await FeaturedPlaylistHttp()
                                            .deleteFeaturedPlaylist(
                                                snapshot.data![index].id!);
                                        Navigator.pop(context);
                                        setState(() {
                                          featuredPlaylists =
                                              FeaturedPlaylistHttp()
                                                  .getFeaturedPlaylist(
                                                      featuredPlaylistNum);
                                        });
                                        Fluttertoast.showToast(
                                          msg: snapshot.data![index].title! +
                                              " featured playlist has been deleted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.primary,
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => FeaturedPlaylistSong(
                                    featuredPlaylistId:
                                        snapshot.data![index].id,
                                    title: snapshot.data![index].title!,
                                    featuredPlaylistImage: snapshot
                                        .data![index].featured_playlist_image,
                                    like: snapshot.data![index].like,
                                    pageIndex: 0,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      height: sHeight * 0.2,
                                      width: sWidth * 0.46,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        featuredPlaylistImage +
                                            snapshot.data![index]
                                                .featured_playlist_image!,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].title!,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                        final resData = await FeaturedPlaylistHttp()
                            .getFeaturedPlaylist(featuredPlaylistNum + 10);
                        if (resData.length == featuredPlaylistNum) {
                          setState(() {
                            more = false;
                          });
                          return;
                        } else {
                          featuredPlaylistNum = featuredPlaylistNum + 10;
                          setState(() {
                            featuredPlaylists = FeaturedPlaylistHttp()
                                .getFeaturedPlaylist(featuredPlaylistNum);
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
        pageIndex: 0,
      ),
    );
  }
}
