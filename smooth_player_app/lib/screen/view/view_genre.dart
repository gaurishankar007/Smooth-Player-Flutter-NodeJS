import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/api/urls.dart';

import '../../api/res/song_res.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';
import '../library/add_playlist_song.dart';
import '../report_song.dart';

class ViewGenre extends StatefulWidget {
  final String? genre;
  final int? pageIndex;
  const ViewGenre({
    Key? key,
    @required this.genre,
    @required this.pageIndex,
  }) : super(
          key: key,
        );

  @override
  State<ViewGenre> createState() => _ViewGenreState();
}

class _ViewGenreState extends State<ViewGenre> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;

  Song? song = Player.playingSong;
  List<Song> songs = [];
  int songNum = 10;
  late int songsLength;
  bool more = true;

  late Future<List<Song>> genreSongs;

  late StreamSubscription stateSub;

  Future<List<Song>> viewSongs() async {
    List<Song> resData =
        await SongHttp().viewGenreSongs(widget.genre!, songNum);
    songs = resData;
    songsLength = resData.length;
    return resData;
  }

  @override
  void initState() {
    super.initState();

    genreSongs = viewSongs();

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
          widget.genre!,
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
          left: sWidth * .04,
          right: sWidth * .04,
          top: 10,
          bottom: 80,
        ),
        child: Column(
          children: [
            FutureBuilder<List<Song>>(
              future: genreSongs,
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
                                              BorderRadius.circular(8),
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
                                              scrollDirection: Axis.horizontal,
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
                                                                  .data![index]
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
                                              scrollDirection: Axis.horizontal,
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
                                                                  .data![index]
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
                                        snapshot.data![index].like!.toString(),
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
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => SimpleDialog(
                                              children: [
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 75,
                                                  ),
                                                  child: ElevatedButton(
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
                                                      Navigator.of(ctx).pop();

                                                      Player.songQueue.add(
                                                        Song(
                                                          id: snapshot
                                                              .data![index].id!,
                                                          title: snapshot
                                                              .data![index]
                                                              .title!,
                                                          album: snapshot
                                                              .data![index]
                                                              .album!,
                                                          music_file: snapshot
                                                              .data![index]
                                                              .music_file!,
                                                          cover_image: snapshot
                                                              .data![index]
                                                              .cover_image!,
                                                          like: snapshot
                                                              .data![index]
                                                              .like!,
                                                        ),
                                                      );
                                                      Fluttertoast.showToast(
                                                        msg: snapshot
                                                                .data![index]
                                                                .title! +
                                                            " is added to the queue.",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 3,
                                                      );
                                                    },
                                                    child: Text("Add to queue"),
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 75,
                                                  ),
                                                  child: ElevatedButton(
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
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (builder) =>
                                                              AddSongToPlaylist(
                                                            songId: snapshot
                                                                .data![index]
                                                                .id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        Text("Add to playlist"),
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 75,
                                                  ),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.red,
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
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (builder) =>
                                                              ReportSong(
                                                            songId: snapshot
                                                                .data![index]
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
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            more
                ? OutlinedButton(
                    onPressed: () async {
                      final resData = await SongHttp()
                          .viewGenreSongs(widget.genre!, songNum + 10);
                      songs = resData;
                      if (resData.length == songsLength) {
                        setState(() {
                          more = false;
                        });
                        return;
                      } else {
                        songNum = songNum + 10;
                        songsLength = resData.length;
                        setState(() {
                          genreSongs =
                              SongHttp().viewGenreSongs(widget.genre!, songNum);
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
          ],
        ),
      ),
      floatingActionButton: song != null
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
