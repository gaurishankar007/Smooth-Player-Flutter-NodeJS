import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/library_http.dart';
import 'package:smooth_player_app/api/res/library_res.dart';
import 'package:smooth_player_app/screen/library/followed_artist.dart';
import 'package:smooth_player_app/screen/library/liked_album.dart';
import 'package:smooth_player_app/screen/library/liked_featured_playlist.dart';
import 'package:smooth_player_app/screen/view/view_album.dart';
import 'package:smooth_player_app/screen/view/view_artist.dart';
import 'package:smooth_player_app/screen/view/view_genre.dart';

import '../api/urls.dart';
import '../resource/colors.dart';
import '../resource/player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';
import 'library/liked_song.dart';
import 'library/playlist.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;
  final profileUrl = ApiUrls.profileUrl;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;
  int libraryIndex = 0;

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            left: sWidth * 0.03,
            right: sWidth * 0.03,
          ),
          child: FutureBuilder<LibraryData>(
              future: LibraryHttp().viewLibrary(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Library",
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              profileUrl + snapshot.data!.profilePicture!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (snapshot.data!.checkPlaylists! ||
                                snapshot.data!.checkFollows! ||
                                snapshot.data!.checkLikedSongs! ||
                                snapshot.data!.checkLikedAlbums! ||
                                snapshot.data!.checkLikedFeaturedPlaylists!)
                            ? Row(
                                children: [
                                  (snapshot.data!.checkPlaylists! ||
                                          snapshot.data!.checkLikedSongs!)
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (builder) =>
                                                    ViewPlaylist(
                                                  profilePic: snapshot
                                                      .data!.profilePicture!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Playlist",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  snapshot.data!.checkFollows!
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (builder) =>
                                                    ViewFollowedArtist(
                                                  profilePic: snapshot
                                                      .data!.profilePicture!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Artist",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  snapshot.data!.checkLikedAlbums!
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (builder) =>
                                                    LikedAlbum(
                                                  profilePic: snapshot
                                                      .data!.profilePicture!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Album",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  snapshot.data!.checkLikedFeaturedPlaylists!
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (builder) =>
                                                    LikedFeaturedPlaylist(
                                                  profilePic: snapshot
                                                      .data!.profilePicture!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Featured Playlist",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      snapshot.data!.checkLikedSongs!
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => ViewLikedSong(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 65,
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.favorite,
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
                                            "Liked Songs",
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
                            )
                          : SizedBox(),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.albums!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewAlbum(
                                    albumId: snapshot.data!.albums![index].id!,
                                    title: snapshot.data!.albums![index].title!,
                                    albumImage: snapshot
                                        .data!.albums![index].album_image!,
                                    pageIndex: 2,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 65,
                                            height: 65,
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
                                                  BorderRadius.circular(5),
                                              child: Image(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  coverImage +
                                                      snapshot
                                                          .data!
                                                          .albums![index]
                                                          .album_image!,
                                                ),
                                              ),
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    snapshot.data!
                                                        .albums![index].title!,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Player
                                                                  .playingSong !=
                                                              null
                                                          ? Player.playingSong!
                                                                      .album!.id ==
                                                                  snapshot
                                                                      .data!
                                                                      .albums![
                                                                          index]
                                                                      .id!
                                                              ? AppColors
                                                                  .primary
                                                              : AppColors.text
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
                                                        .data!
                                                        .albums![index]
                                                        .artist!
                                                        .profile_name!,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      color: Player
                                                                  .playingSong !=
                                                              null
                                                          ? Player.playingSong!
                                                                      .album!.id ==
                                                                  snapshot
                                                                      .data!
                                                                      .albums![
                                                                          index]
                                                                      .id!
                                                              ? AppColors
                                                                  .primary
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
                                    ],
                                  ),
                                  Player.playingSong != null
                                      ? Player.playingSong!.album!.id ==
                                              snapshot.data!.albums![index].id!
                                          ? Icon(
                                              Icons.bar_chart_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            )
                                          : SizedBox()
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.artists!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewArtist(
                                    artistId:
                                        snapshot.data!.artists![index].id!,
                                    pageIndex: 2,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
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
                                              BorderRadius.circular(35),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              profileUrl +
                                                  snapshot.data!.artists![index]
                                                      .profile_picture!,
                                            ),
                                          ),
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
                                                snapshot.data!.artists![index]
                                                    .profile_name!,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Player.playingSong !=
                                                          null
                                                      ? Player
                                                                  .playingSong!
                                                                  .album!
                                                                  .artist!
                                                                  .id ==
                                                              snapshot
                                                                  .data!
                                                                  .artists![
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
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                "Artist",
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                  color: Player.playingSong !=
                                                          null
                                                      ? Player
                                                                  .playingSong!
                                                                  .album!
                                                                  .artist!
                                                                  .id ==
                                                              snapshot
                                                                  .data!
                                                                  .artists![
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
                                  Player.playingSong != null
                                      ? Player.playingSong!.album!.id ==
                                              snapshot.data!.albums![index].id!
                                          ? Icon(
                                              Icons.bar_chart_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            )
                                          : SizedBox()
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.genres!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ViewGenre(
                                    genre: snapshot.data!.genres![index],
                                    pageIndex: 2,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Row(
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.group_work_rounded,
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
                                            snapshot.data!.genres![index],
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
                                            "Genre",
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
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.userPlaylists!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Row(
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
                                      borderRadius: BorderRadius.circular(5),
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
                                            snapshot.data!.userPlaylists![index]
                                                .title!,
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
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
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
