import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/featured_song_http.dart';
import 'package:smooth_player_app/api/res/featured_song_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';
import 'package:smooth_player_app/api/urls.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/player.dart';
import 'package:smooth_player_app/screen/upload/upload_album_song.dart';
import 'package:smooth_player_app/widget/admin_navigator.dart';
import 'package:smooth_player_app/widget/song_bar.dart';


class FeaturedPlaylistSong extends StatefulWidget {
  final String? featuredPlaylistId;
  final String? title;
  final String? featuredPlaylistImage;
  final int? pageIndex;
  const FeaturedPlaylistSong(
      {Key? key,
      @required this.featuredPlaylistId,
      @required this.title,
      @required this.featuredPlaylistImage,
      @required this.pageIndex})
      : super(key: key);

  @override
  State<FeaturedPlaylistSong> createState() => _FeaturedPlaylistSongState();
}

class _FeaturedPlaylistSongState extends State<FeaturedPlaylistSong> {
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;
  final featuredplaylistImage = ApiUrls.featuredPlaylistUrl;


  late Future<List<FeaturedSong>> featuredPlaylistSongs;

  late List<Song> songs;

  Future<List<FeaturedSong>> viewSongs() async {
    List<FeaturedSong> resData = await FeaturedSongHttp().getFeaturedSongs(widget.featuredPlaylistId!);
    return resData;
  }

  @override
  void initState() {
    super.initState();

    viewSongs().then((value) {
      for (int i = 0; i < value.length; i++) {
        songs.add(value[i].song!);
      }
    });

    featuredPlaylistSongs = FeaturedSongHttp().getFeaturedSongs(widget.featuredPlaylistId!);
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
                        featuredplaylistImage + widget.featuredPlaylistImage!,
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
              child: FutureBuilder<List<FeaturedSong>>(
                future: featuredPlaylistSongs,
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
                                music_file: snapshot.data![index].song!.music_file!,
                                cover_image: snapshot.data![index].song!.cover_image!,
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
                                                    snapshot.data![index].
                                                        song!.cover_image!,
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
                                            snapshot.data![index].song!.title!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Player.playingSong != null
                                                  ? Player.playingSong!.id ==
                                                          snapshot
                                                              .data![index].song!.id!
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
                                          snapshot.data![index].song!.like!
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
                                      },
                                      icon: Icon(
                                        Icons.delete_rounded,
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
      bottomNavigationBar: AdminPageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
