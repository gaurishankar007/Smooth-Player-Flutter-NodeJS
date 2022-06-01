import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/widget/admin_navigator.dart';
import '../../api/http/song_http.dart';
import '../../api/res/song_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/song_bar.dart';

class ViewAdminAlbum extends StatefulWidget {
  final String? albumId;
  final String? title;
  final String? albumImage;
  final int? like;
  final int? pageIndex;
  const ViewAdminAlbum({
    Key? key,
    @required this.albumId,
    @required this.title,
    @required this.albumImage,
    @required this.like,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<ViewAdminAlbum> createState() => _ViewAdminAlbumState();
}

class _ViewAdminAlbumState extends State<ViewAdminAlbum> {
  final AudioPlayer player = Player.player;
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;

  late Future<List<Song>> albumSongs;

  List<Song> songs = [];

  late StreamSubscription stateSub;

  Future<List<Song>> viewSongs() async {
    List<Song> resData = await SongHttp().getSongsAdmin(widget.albumId!);
    return resData;
  }

  @override
  void initState() {
    super.initState();

    viewSongs().then((value) {
      songs = value;
    });

    albumSongs = SongHttp().getSongsAdmin(widget.albumId!);

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
                        coverImage + widget.albumImage!,
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
              child: FutureBuilder<List<Song>>(
                future: albumSongs,
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
                                id: snapshot.data![index].id!,
                                title: snapshot.data![index].title!,
                                album: snapshot.data![index].album!,
                                music_file: snapshot.data![index].music_file!,
                                cover_image: snapshot.data![index].cover_image!,
                                like: snapshot.data![index].like!,
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
                                            snapshot.data![index].id!
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
                                                    snapshot.data![index]
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
                                                  snapshot.data![index].title!,
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
                                                  snapshot.data![index].album!
                                                      .artist!.profile_name!,
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
                                          snapshot.data![index].like!
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
                                          onPressed: () {
                                            Player.songQueue.add(
                                              Song(
                                                id: snapshot.data![index].id!,
                                                title: snapshot
                                                    .data![index].title!,
                                                album: snapshot
                                                    .data![index].album!,
                                                music_file: snapshot
                                                    .data![index].music_file!,
                                                cover_image: snapshot
                                                    .data![index].cover_image!,
                                                like:
                                                    snapshot.data![index].like!,
                                              ),
                                            );
                                            Fluttertoast.showToast(
                                              msg:
                                                  snapshot.data![index].title! +
                                                      " is added to the queue.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 3,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.add_to_queue,
                                            color: AppColors.primary,
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
      bottomNavigationBar: AdminPageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
