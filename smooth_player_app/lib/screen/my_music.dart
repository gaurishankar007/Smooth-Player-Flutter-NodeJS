import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/urls.dart';
// import 'package:music_app/api/http/album_http.dart';
// import 'package:music_app/api/log_status.dart';
// import 'package:music_app/screens/album.dart';
// import 'package:music_app/widgets/navigator.dart';
// import 'package:music_app/widgets/song_bar.dart';
import 'package:smooth_player_app/screen/albums.dart';

import '../api/http/album_http.dart';
import '../api/log_status.dart';
import '../api/res/album_res.dart';
import '../player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';

class MyMusic extends StatefulWidget {
  final String? albumId;
  const MyMusic({Key? key, @required this.albumId}) : super(key: key);

  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  final AudioPlayer player = Player.player;
  final albumUrl = ApiUrls.albumUrl;

  late Future<List<Album>> albums;

  late StreamSubscription stateSub;

  bool songBarVisibility = false;

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
                      // key: Key("ButtonAddAlbum"),
                      onPressed: () {},
                      child: Text(
                        "Upload Album",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      // key: Key("dsklfj"),
                      onPressed: () {},
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
                        bottom: 20,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return GestureDetector(
                            onLongPress: () {
                              // shoswDialog(context: context, builder: (builder)=> );
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Alert Dialog Box"),
                                  content: Text(
                                      "You have raised a Alert Dialog Box"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        await AlbumHttp().deleteAlbum(
                                            snapshot.data![index].id);
                                        Navigator.pop(context);
                                        setState(() {
                                          albums = AlbumHttp().getAlbums();
                                        });
                                        Fluttertoast.showToast(
                                          msg: snapshot.data![index].title! +
                                              " album has been deleted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor:
                                              Color.fromARGB(255, 54, 244, 54),
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("no"),
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
                                    album_image:
                                        snapshot.data![index].album_image,
                                    pageIndex: 3,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: sWidth * 0.455,
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
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          albumUrl +
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
                                ]),
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
