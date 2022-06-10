import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/like_http.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/screen/view/view_featured_playlist.dart';
import 'package:smooth_player_app/widget/navigator.dart';

import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/song_bar.dart';

class LikedFeaturedPlaylist extends StatefulWidget {
  final String? profilePic;
  const LikedFeaturedPlaylist({Key? key, @required this.profilePic})
      : super(key: key);

  @override
  State<LikedFeaturedPlaylist> createState() => _LikedFeaturedPlaylistState();
}

class _LikedFeaturedPlaylistState extends State<LikedFeaturedPlaylist> {
  final AudioPlayer player = Player.player;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;
  final profileUrl = ApiUrls.profileUrl;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: sHeight * .01,
            left: sWidth * .03,
            right: sWidth * .03,
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
                      "Featured Playlist",
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
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<FeaturedPlaylist>>(
                future: LikeHttp().viewLikedFeaturedPlaylists(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewFeaturedPlaylist(
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
      bottomNavigationBar: PageNavigator(
        pageIndex: 2,
      ),
    );
  }
}
