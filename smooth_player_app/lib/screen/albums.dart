import 'package:flutter/material.dart';
import 'package:smooth_player_app/colors.dart';

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
  final songUrl = ApiUrls.songCoverUrl;
  final albumUrl = ApiUrls.albumUrl;

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
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
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
                ClipRRect(
                  child: Image(
                    width: sWidth * .75,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      albumUrl + widget.album_image!,
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
                    width: sWidth * .35,
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
                    onPressed: () {},
                    child: Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
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
              ),
              child: FutureBuilder<List<Song>>(
                future: viewSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("${index + 1}"),
                                  SizedBox(
                                    width: 20,
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
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          songUrl +
                                              snapshot
                                                  .data![index].cover_image!,
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Color.fromARGB(255, 221, 14, 14),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    snapshot.data![index].like!.toString(),
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
                                  Player.songQueue.add(Song(
                                    id: snapshot.data![index].id!,
                                    title: snapshot.data![index].title!,
                                    album: snapshot.data![index].album!,
                                    music_file:
                                        snapshot.data![index].music_file!,
                                    cover_image:
                                        snapshot.data![index].cover_image!,
                                    like: snapshot.data![index].like!,
                                  ));
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                ),
                              ),
                            ],
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
