import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/like_http.dart';

import '../../api/http/featured_song_http.dart';
import '../../api/res/featured_song_res.dart';
import '../../api/res/song_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';
import '../library/add_playlist_song.dart';
import '../report_song.dart';

class ViewFeaturedPlaylist extends StatefulWidget {
  final String? featuredPlaylistId;
  final String? title;
  final String? featuredPlaylistImage;
  final int? like;
  final int? pageIndex;
  const ViewFeaturedPlaylist({
    Key? key,
    @required this.featuredPlaylistId,
    @required this.title,
    @required this.featuredPlaylistImage,
    @required this.like,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<ViewFeaturedPlaylist> createState() => _ViewFeaturedPlaylistState();
}

class _ViewFeaturedPlaylistState extends State<ViewFeaturedPlaylist> {
  final AudioPlayer player = Player.player;
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;
  final featuredPlaylistUrl = ApiUrls.featuredPlaylistUrl;

  List<Song> songs = [];
  bool featuredPlaylistLike = false;

  late StreamSubscription stateSub;

  void viewSongs() async {
    List<FeaturedSong> resData =
        await FeaturedSongHttp().viewFeaturedSongs(widget.featuredPlaylistId!);
    for (int i = 0; i < resData.length; i++) {
      songs.add(resData[i].song!);
    }

    bool featuredPlaylistLike1 =
        await LikeHttp().checkFeaturedPlaylistLike(widget.featuredPlaylistId!);
    setState(() {
      featuredPlaylistLike = featuredPlaylistLike1;
    });
  }

  @override
  void initState() {
    super.initState();

    viewSongs();

    stateSub = player.onPlayerStateChanged.listen((state) {
      setState(() {
        song = Player.playingSong;
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
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                      width: sWidth * .8,
                      height: sHeight * .3,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        featuredPlaylistUrl + widget.featuredPlaylistImage!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: sWidth * 0.03,
                right: sWidth * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: sWidth * .7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.title!,
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.like!.toString() + " likes",
                            style: TextStyle(
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final resData = await LikeHttp().likeFeaturedPlaylist(
                          widget.featuredPlaylistId!, widget.title!);
                      Fluttertoast.showToast(
                        msg: resData["resM"],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                      setState(() {
                        featuredPlaylistLike = !featuredPlaylistLike;
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: featuredPlaylistLike
                          ? AppColors.primary
                          : AppColors.text,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: sWidth * 0.03,
                right: sWidth * 0.03,
                bottom: 80,
              ),
              child: FutureBuilder<List<FeaturedSong>>(
                future: FeaturedSongHttp()
                    .viewFeaturedSongs(widget.featuredPlaylistId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onDoubleTap: () async {
                              Song newSong = Song(
                                id: snapshot.data![index].song!.id!,
                                title: snapshot.data![index].song!.title!,
                                album: snapshot.data![index].song!.album!,
                                music_file:
                                    snapshot.data![index].song!.music_file!,
                                cover_image:
                                    snapshot.data![index].song!.cover_image!,
                                like: snapshot.data![index].song!.like!,
                              );

                              Player().playSong(newSong, songs);

                              setState(() {
                                song = newSong;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Player.playingSong != null
                                    ? Player.playingSong!.id ==
                                            snapshot.data![index].song!.id!
                                        ? Icon(
                                            Icons.bar_chart_rounded,
                                            color: AppColors.primary,
                                          )
                                        : Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                    : Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          width: 50,
                                          height: 50,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                coverImage +
                                                    snapshot.data![index].song!
                                                        .cover_image!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: sWidth * .35,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  snapshot.data![index].song!
                                                      .title!,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Player.playingSong !=
                                                            null
                                                        ? Player.playingSong!
                                                                    .id ==
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .song!
                                                                    .id!
                                                            ? AppColors.primary
                                                            : AppColors.text
                                                        : AppColors.text,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                                    color: Player.playingSong !=
                                                            null
                                                        ? Player.playingSong!
                                                                    .id ==
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .song!
                                                                    .id!
                                                            ? AppColors.primary
                                                            : AppColors.text
                                                        : AppColors.text,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].song!.like!
                                              .toString(),
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: AppColors.text,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: AppColors.primary,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          constraints: BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => SimpleDialog(
                                                children: [
                                                  SimpleDialogOption(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 75,
                                                    ),
                                                    child: ElevatedButton(
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
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();

                                                        Player.songQueue.add(
                                                          Song(
                                                            id: snapshot
                                                                .data![index]
                                                                .song!
                                                                .id!,
                                                            title: snapshot
                                                                .data![index]
                                                                .song!
                                                                .title!,
                                                            album: snapshot
                                                                .data![index]
                                                                .song!
                                                                .album!,
                                                            music_file: snapshot
                                                                .data![index]
                                                                .song!
                                                                .music_file!,
                                                            cover_image: snapshot
                                                                .data![index]
                                                                .song!
                                                                .cover_image!,
                                                            like: snapshot
                                                                .data![index]
                                                                .song!
                                                                .like!,
                                                          ),
                                                        );
                                                        Fluttertoast.showToast(
                                                          msg: snapshot
                                                                  .data![index]
                                                                  .song!
                                                                  .title! +
                                                              " is added to the queue.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 3,
                                                        );
                                                      },
                                                      child:
                                                          Text("Add to queue"),
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 75,
                                                    ),
                                                    child: ElevatedButton(
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
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (builder) =>
                                                                AddSongToPlaylist(
                                                              songId: snapshot
                                                                  .data![index]
                                                                  .song!
                                                                  .id,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Add to playlist"),
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 75,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.red,
                                                        elevation: 10,
                                                        shadowColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (builder) =>
                                                                    ReportSong(
                                                              songId: snapshot
                                                                  .data![index]
                                                                  .song!
                                                                  .id,
                                                              pageIndex: widget
                                                                  .pageIndex,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text("Report"),
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
                                  ],
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
                      color: Colors.greenAccent,
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: song != null
          ? SongBar(
              songData: song,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: PageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
