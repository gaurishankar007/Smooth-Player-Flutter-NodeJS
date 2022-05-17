import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/urls.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/screen/albums.dart';
import 'package:smooth_player_app/screen/upload/edit_album.dart';
import 'package:smooth_player_app/screen/upload/upload_album.dart';
import 'package:smooth_player_app/screen/upload/upload_song.dart';

import '../api/http/album_http.dart';
import '../api/log_status.dart';
import '../api/res/album_res.dart';
import '../player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({Key? key}) : super(key: key);

  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;

  late Future<List<Album>> albums;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();

    albums = AlbumHttp().getAlbums();

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
          child: Column(
            children: [
              SizedBox(
                height: sHeight * .01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sWidth * 0.03, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                                builder: (context) => UploadAlbum()));
                      },
                      child: Text(
                        "Upload Album",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                                builder: (context) => UploadSong()));
                      },
                      child: Text(
                        "Upload Song",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: sHeight * .01,
              ),
              FutureBuilder<List<Album>>(
                future: albums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      padding: EdgeInsets.only(
                        top: sHeight * .01,
                        left: sWidth * .03,
                        right: sWidth * .03,
                        bottom: 80,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return GestureDetector(
                            onLongPress: () {
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
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => EditAlbum(
                                                albumId:
                                                    snapshot.data![index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Edit"),
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
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Delete " +
                                                  snapshot.data![index].title!),
                                              content: Text(
                                                  "Are you sure you want to delete this album? All the songs in this album will be also deleted."),
                                              actions: <Widget>[
                                                ElevatedButton(
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
                                                    await AlbumHttp()
                                                        .deleteAlbum(snapshot
                                                            .data![index].id!);
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      albums = AlbumHttp()
                                                          .getAlbums();
                                                    });
                                                    Fluttertoast.showToast(
                                                      msg: snapshot.data![index]
                                                              .title! +
                                                          " album has been deleted",
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
                                                ElevatedButton(
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
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => AlbumView(
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
                              alignment: Alignment.center,
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
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          height: sHeight * 0.2,
                                          width: sWidth * 0.44,
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
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 27, 11, 11),
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
                                            size: 80,
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
                      color: Colors.greenAccent,
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
        pageIndex: 3,
      ),
    );
  }
}
