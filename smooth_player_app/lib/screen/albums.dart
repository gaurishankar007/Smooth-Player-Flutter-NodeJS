import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/screen/upload/upload_album_song.dart';

import '../api/http/song_http.dart';
import '../api/res/song_res.dart';
import '../api/urls.dart';
import '../player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';

class AlbumView extends StatefulWidget {
  final String? albumId;
  final String? title;
  final String? album_image;
  final int? pageIndex;
  const AlbumView(
      {Key? key,
      @required this.albumId,
      @required this.title,
      @required this.album_image,
      @required this.pageIndex})
      : super(key: key);

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;

  late Future<List<Song>> albumSongs;

  late List<Song> songs;

  Future<List<Song>> viewSongs() async {
    List<Song> resData = await SongHttp().getSongs(widget.albumId!);
    return resData;
  }

  @override
  void initState() {
    super.initState();

    viewSongs().then((value) {
      setState(() {
        songs = value;
      });
    });

    albumSongs = SongHttp().getSongs(widget.albumId!);
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
                  padding: EdgeInsets.only(left: 10),
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
                      width: sWidth * .75,
                      height: sHeight * .3,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        coverImage + widget.album_image!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: sWidth * 0.05,
                right: sWidth * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: sWidth * .5,
                    child: Text(
                      widget.title!,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadAlbumSong(
                            albumId: widget.albumId!,
                            title: widget.title,
                            album_image: widget.album_image,
                            pageIndex: widget.pageIndex,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      minimumSize: Size.zero,
                      primary: AppColors.primary,
                      elevation: 10,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: sWidth * 0.05,
                right: sWidth * 0.05,
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
                            onTap: () async {
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
                                          width: 40,
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
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: sWidth * .35,
                                          child: Text(
                                            snapshot.data![index].title!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Player.playingSong != null
                                                  ? Player.playingSong!.id ==
                                                          snapshot
                                                              .data![index].id!
                                                      ? AppColors.primary
                                                      : Colors.black
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color:
                                              Color.fromARGB(255, 221, 14, 14),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].like!
                                              .toString(),
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
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
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();

                                                    // Player.songQueue.add(
                                                    //   Song(
                                                    //     id: snapshot
                                                    //         .data![index].id!,
                                                    //     title: snapshot
                                                    //         .data![index]
                                                    //         .title!,
                                                    //     album: snapshot
                                                    //         .data![index]
                                                    //         .album!,
                                                    //     music_file: snapshot
                                                    //         .data![index]
                                                    //         .music_file!,
                                                    //     cover_image: snapshot
                                                    //         .data![index]
                                                    //         .cover_image!,
                                                    //     like: snapshot
                                                    //         .data![index].like!,
                                                    //   ),
                                                    // );
                                                    // Fluttertoast.showToast(
                                                    //   msg: snapshot.data![index]
                                                    //           .title! +
                                                    //       " is added to the queue.",
                                                    //   toastLength:
                                                    //       Toast.LENGTH_SHORT,
                                                    //   gravity:
                                                    //       ToastGravity.BOTTOM,
                                                    //   timeInSecForIosWeb: 3,
                                                    // );
                                                  },
                                                  child: Text("Add to queue"),
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
                                                    await SongHttp().deleteSong(
                                                        snapshot
                                                            .data![index].id!);

                                                    Navigator.pop(context);

                                                    setState(() {
                                                      albumSongs = SongHttp()
                                                          .getSongs(
                                                              widget.albumId!);
                                                    });

                                                    Fluttertoast.showToast(
                                                      msg: snapshot.data![index]
                                                              .title! +
                                                          " song has been deleted",
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