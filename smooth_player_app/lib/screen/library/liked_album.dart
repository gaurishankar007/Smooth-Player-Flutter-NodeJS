import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/like_http.dart';
import 'package:smooth_player_app/api/urls.dart';
import 'package:smooth_player_app/resource/colors.dart';
import 'package:smooth_player_app/screen/view/view_album.dart';

import '../../api/res/album_res.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';

class LikedAlbum extends StatefulWidget {
  final String? profilePic;
  const LikedAlbum({Key? key, @required this.profilePic}) : super(key: key);

  @override
  State<LikedAlbum> createState() => _LikedAlbumState();
}

class _LikedAlbumState extends State<LikedAlbum> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;
  final profileUrl = ApiUrls.profileUrl;

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
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            top: 10,
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
                      "Album",
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
              FutureBuilder<List<Album>>(
                future: LikeHttp().viewLikedAlbums(),
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
                                  builder: (builder) => ViewAlbum(
                                    albumId: snapshot.data![index].id,
                                    title: snapshot.data![index].title!,
                                    albumImage:
                                        snapshot.data![index].album_image,
                                    pageIndex: 3,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Column(
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
                                            coverImage +
                                                snapshot
                                                    .data![index].album_image!,
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
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Player.playingSong != null
                                    ? Player.playingSong!.album!.id ==
                                            snapshot.data![index].id
                                        ? Icon(
                                            Icons.bar_chart_rounded,
                                            color: AppColors.primary,
                                            size: 40,
                                          )
                                        : SizedBox()
                                    : SizedBox(),
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
