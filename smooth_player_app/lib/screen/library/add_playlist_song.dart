import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/playlist_http.dart';
import 'package:smooth_player_app/api/http/playlist_song_http.dart';
import 'package:smooth_player_app/api/res/playlist_res.dart';
import 'package:smooth_player_app/screen/library/playlist_song.dart';

import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';

class AddSongToPlaylist extends StatefulWidget {
  final String? songId;
  const AddSongToPlaylist({Key? key, @required this.songId}) : super(key: key);

  @override
  State<AddSongToPlaylist> createState() => _AddSongToPlaylistState();
}

class _AddSongToPlaylistState extends State<AddSongToPlaylist> {
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
          "Add song to playlist",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            bottom: 80,
          ),
          child: Column(
            children: [
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
                            onTap: () async {
                              final resData = await PlaylistSongHttp()
                                  .addPlaylistSong(snapshot.data![index].id!,
                                      widget.songId!);
                              Navigator.pop(context);

                              Fluttertoast.showToast(
                                msg: resData["resM"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) =>
                                              ViewPlaylistSong(
                                            playlistId:
                                                snapshot.data![index].id,
                                            playlistTitle:
                                                snapshot.data![index].title,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: AppColors.primary,
                                    ),
                                  )
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
