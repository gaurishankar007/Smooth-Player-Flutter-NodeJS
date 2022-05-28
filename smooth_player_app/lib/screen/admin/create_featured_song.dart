import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/featured_song_http.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist_song.dart';

import '../../api/http/song_http.dart';
import '../../api/res/song_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/song_bar.dart';

class CreateFeaturedSong extends StatefulWidget {
  final String? featuredPlaylistId;
  final String? title;
  final String? featuredPlaylistImage;
  final int? like;
  final int? pageIndex;
  const CreateFeaturedSong({
    Key? key,
    @required this.featuredPlaylistId,
    @required this.title,
    @required this.featuredPlaylistImage,
    @required this.like,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<CreateFeaturedSong> createState() => _CreateFeaturedSongState();
}

class _CreateFeaturedSongState extends State<CreateFeaturedSong> {
  final coverImage = ApiUrls.coverImageUrl;
  bool searching = false;
  List<Song> selectedSongs = [];
  List<String> selectedSongsId = [];

  late Future<List<Song>> searchedSongs;

  Song? song = Player.playingSong;

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  @override
  void initState() {
    super.initState();

    searchedSongs = SongHttp().searchSongByTitle("");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search and Add Song",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: screenWidth * .02,
          right: screenWidth * .02,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * .65,
                  child: TextField(
                    onChanged: ((value) {
                      if (value.isEmpty) {
                        setState(() {
                          searchedSongs = SongHttp().searchSongByTitle("");
                        });
                      } else {
                        setState(() {
                          searching = true;
                          searchedSongs =
                              SongHttp().searchSongByTitle(value.trim());
                        });
                      }
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.form,
                      hintText: "Enter song title",
                      enabledBorder: formBorder,
                      focusedBorder: formBorder,
                      errorBorder: formBorder,
                      focusedErrorBorder: formBorder,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searching = !searching;
                    });
                  },
                  child: searching
                      ? Text(
                          "Selected",
                        )
                      : Text(
                          "Searched",
                        ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    elevation: 10,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            searching
                ? Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * .02,
                      right: screenWidth * .02,
                    ),
                    child: FutureBuilder<List<Song>>(
                      future: searchedSongs,
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
                                      music_file:
                                          snapshot.data![index].music_file!,
                                      cover_image:
                                          snapshot.data![index].cover_image!,
                                      like: snapshot.data![index].like!,
                                    );

                                    setState(() {
                                      song = newSong;
                                    });

                                    List<Song> searchedSongs = [newSong];

                                    Player().playSong(newSong, searchedSongs);
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
                                                width: screenWidth * .35,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        snapshot.data![index]
                                                            .title!,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Player
                                                                      .playingSong !=
                                                                  null
                                                              ? Player.playingSong!
                                                                          .id ==
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .id!
                                                                  ? AppColors
                                                                      .primary
                                                                  : AppColors
                                                                      .text
                                                              : AppColors.text,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                            .album!
                                                            .artist!
                                                            .profile_name!,
                                                        style: TextStyle(
                                                          color: Player
                                                                      .playingSong !=
                                                                  null
                                                              ? Player.playingSong!
                                                                          .id ==
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .id!
                                                                  ? AppColors
                                                                      .primary
                                                                  : AppColors
                                                                      .text
                                                              : AppColors.text,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          selectedSongsId.contains(
                                                  snapshot.data![index].id!)
                                              ? SizedBox()
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    if (selectedSongs.isEmpty) {
                                                      selectedSongs.add(Song(
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
                                                            .data![index].like!,
                                                      ));
                                                      setState(() {
                                                        selectedSongsId.add(
                                                            snapshot
                                                                .data![index]
                                                                .id!);
                                                      });
                                                      Fluttertoast.showToast(
                                                        msg: "'" +
                                                            snapshot
                                                                .data![index]
                                                                .title! +
                                                            "'"
                                                                " song added to queue list",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    } else if (selectedSongsId
                                                        .contains(snapshot
                                                            .data![index]
                                                            .id!)) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Song already added",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    } else {
                                                      selectedSongs.add(Song(
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
                                                            .data![index].like!,
                                                      ));
                                                      setState(() {
                                                        selectedSongsId.add(
                                                            snapshot
                                                                .data![index]
                                                                .id!);
                                                      });
                                                      Fluttertoast.showToast(
                                                        msg: "'" +
                                                            snapshot
                                                                .data![index]
                                                                .title! +
                                                            "'"
                                                                " song added to queue list",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  },
                                                  child: Text("Add"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.all(8),
                                                    minimumSize: Size.zero,
                                                    primary: AppColors.primary,
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
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
                  )
                : selectedSongs.isNotEmpty
                    ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final resData = await FeaturedSongHttp()
                                  .addFeaturedSongs(widget.featuredPlaylistId!,
                                      selectedSongsId);
                              if (resData["statusCode"] == 201) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => FeaturedPlaylistSong(
                                      featuredPlaylistId:
                                          widget.featuredPlaylistId,
                                      title: widget.title,
                                      featuredPlaylistImage:
                                          widget.featuredPlaylistImage,
                                      like: widget.like,
                                      pageIndex: widget.pageIndex,
                                    ),
                                  ),
                                );
                                Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  msg: resData["body"]["resM"],
                                );
                              }
                            },
                            child: Text("Upload Selected Songs"),
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.primary,
                              elevation: 10,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * .02,
                              right: screenWidth * .02,
                            ),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: selectedSongs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: GestureDetector(
                                    onDoubleTap: () async {
                                      List<Song> searchedSongs = [
                                        selectedSongs[index]
                                      ];

                                      setState(() {
                                        song = selectedSongs[index];
                                      });

                                      Player().playSong(
                                          selectedSongs[index], searchedSongs);
                                    },
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Player.playingSong != null
                                            ? Player.playingSong!.id ==
                                                    selectedSongs[index].id!
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
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        coverImage +
                                                            selectedSongs[index]
                                                                .cover_image!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * .35,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          selectedSongs[index]
                                                              .title!,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Player
                                                                        .playingSong !=
                                                                    null
                                                                ? Player.playingSong!
                                                                            .id ==
                                                                        selectedSongs[index]
                                                                            .id!
                                                                    ? AppColors
                                                                        .primary
                                                                    : AppColors
                                                                        .text
                                                                : AppColors
                                                                    .text,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                          selectedSongs[index]
                                                              .album!
                                                              .artist!
                                                              .profile_name!,
                                                          style: TextStyle(
                                                            color: Player
                                                                        .playingSong !=
                                                                    null
                                                                ? Player.playingSong!
                                                                            .id ==
                                                                        selectedSongs[index]
                                                                            .id!
                                                                    ? AppColors
                                                                        .primary
                                                                    : AppColors
                                                                        .text
                                                                : AppColors
                                                                    .text,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                for (int i = 0;
                                                    i < selectedSongs.length;
                                                    i++) {
                                                  if (selectedSongs[i].id ==
                                                      selectedSongs[index].id) {
                                                    selectedSongs
                                                        .removeAt(index);
                                                    setState(() {
                                                      selectedSongsId
                                                          .removeAt(index);
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text("Remove"),
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(8),
                                                minimumSize: Size.zero,
                                                primary: Colors.deepOrange,
                                                elevation: 10,
                                                shadowColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: song != null
          ? SongBar(
              songData: song,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
