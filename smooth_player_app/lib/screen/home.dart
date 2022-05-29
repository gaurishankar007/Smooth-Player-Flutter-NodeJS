import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/home_http.dart';
import 'package:smooth_player_app/api/res/home_res.dart';
import 'package:smooth_player_app/screen/setting.dart';
import 'package:smooth_player_app/screen/view/view_album.dart';
import 'package:smooth_player_app/screen/view/view_artist.dart';
import 'package:smooth_player_app/screen/view/view_featured_playlist.dart';
import 'package:smooth_player_app/widget/navigator.dart';

import '../api/urls.dart';
import '../resource/colors.dart';
import '../resource/player.dart';
import '../widget/song_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;
  final profileUrl = ApiUrls.profileUrl;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;

  int curTime = DateTime.now().hour;
  String greeting = "Smooth Player";

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  @override
  void initState() {
    super.initState();
    if (5 <= curTime && 12 >= curTime) {
      greeting = "Good Morning";
    } else if (12 <= curTime && 18 >= curTime) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

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
          padding: EdgeInsets.only(
            top: 10,
            right: sWidth * 0.03,
            bottom: 80,
            left: sWidth * 0.03,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.settings,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => Setting(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<HomeData>(
                future: HomeHttp().viewHome(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        snapshot.data!.recentAlbums!.isNotEmpty
                            ? GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 2 / 1,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                                children: List.generate(
                                  snapshot.data!.recentAlbums!.length,
                                  (index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => ViewAlbum(
                                                albumId: snapshot.data!
                                                    .recentAlbums![index].id,
                                                title: snapshot
                                                    .data!
                                                    .recentAlbums![index]
                                                    .title!,
                                                albumImage: snapshot
                                                    .data!
                                                    .recentAlbums![index]
                                                    .album_image,
                                                like: snapshot.data!
                                                    .recentAlbums![index].like,
                                                pageIndex: 0,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                  colors: const [
                                                    Color(0XFF36D1DC),
                                                    Color(0XFF5B86E5),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(2, 2),
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                    child: Image(
                                                      height: 70,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        coverImage +
                                                            snapshot
                                                                .data!
                                                                .recentAlbums![
                                                                    index]
                                                                .album_image!,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: sWidth * .25,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .recentAlbums![
                                                                index]
                                                            .title!,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          color: AppColors.text,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Player.playingSong != null
                                                ? Player.playingSong!.album!
                                                            .id ==
                                                        snapshot
                                                            .data!
                                                            .recentAlbums![
                                                                index]
                                                            .id
                                                    ? Icon(
                                                        Icons.bar_chart_rounded,
                                                        color:
                                                            AppColors.primary,
                                                        size: 40,
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.recentFavoriteArtists!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "Your recent favorite Artists",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.recentFavoriteArtists!.isNotEmpty
                            ? SizedBox(
                                height: sHeight * 0.3,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot
                                      .data!.recentFavoriteArtists!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => ViewArtist(
                                              artistId: snapshot
                                                  .data!
                                                  .recentFavoriteArtists![index]
                                                  .id,
                                              pageIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            sHeight * .125),
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
                                                            sHeight * .125),
                                                    child: Image(
                                                      height: sHeight * 0.25,
                                                      width: sHeight * 0.25,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        profileUrl +
                                                            snapshot
                                                                .data!
                                                                .recentFavoriteArtists![
                                                                    index]
                                                                .profile_picture!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .recentFavoriteArtists![
                                                          index]
                                                      .profile_name!,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: AppColors.text,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Player.playingSong != null
                                                ? Player.playingSong!.album!
                                                            .artist!.id ==
                                                        snapshot
                                                            .data!
                                                            .recentFavoriteArtists![
                                                                index]
                                                            .id
                                                    ? Icon(
                                                        Icons.bar_chart_rounded,
                                                        color:
                                                            AppColors.primary,
                                                        size: 40,
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.recentFavoriteGenres!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "Your recent favorite Genres",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.recentFavoriteGenres!.isNotEmpty
                            ? SizedBox(
                                height: sHeight * 0.2,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.newReleases!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: sHeight * 0.2,
                                              width: sWidth * 0.46,
                                              decoration: BoxDecoration(
                                                color:
                                                    SongGenreColors.colorList[
                                                        Random().nextInt(
                                                            SongGenreColors
                                                                .colorList
                                                                .length)],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(2, 2),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              width: sWidth * .43,
                                              child: Text(
                                                snapshot.data!
                                                        .recentFavoriteGenres![
                                                    index],
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  color: AppColors.text,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.jumpBackIn!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 25,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "Jump Back In",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.jumpBackIn!.isNotEmpty
                            ? SizedBox(
                                height: sHeight * 0.25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.jumpBackIn!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => ViewAlbum(
                                              albumId: snapshot
                                                  .data!.jumpBackIn![index].id,
                                              title: snapshot.data!
                                                  .jumpBackIn![index].title!,
                                              albumImage: snapshot
                                                  .data!
                                                  .jumpBackIn![index]
                                                  .album_image,
                                              like: snapshot.data!
                                                  .jumpBackIn![index].like,
                                              pageIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      height: sHeight * 0.2,
                                                      width: sWidth * 0.46,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        coverImage +
                                                            snapshot
                                                                .data!
                                                                .jumpBackIn![
                                                                    index]
                                                                .album_image!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .jumpBackIn![index]
                                                      .title!,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: AppColors.text,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Player.playingSong != null
                                                ? Player.playingSong!.album!
                                                            .id ==
                                                        snapshot
                                                            .data!
                                                            .newReleases![index]
                                                            .id
                                                    ? Icon(
                                                        Icons.bar_chart_rounded,
                                                        color:
                                                            AppColors.primary,
                                                        size: 40,
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.newReleases!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "New Releases",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.newReleases!.isNotEmpty
                            ? SizedBox(
                                height: sHeight * 0.25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.newReleases!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => ViewAlbum(
                                              albumId: snapshot
                                                  .data!.newReleases![index].id,
                                              title: snapshot.data!
                                                  .newReleases![index].title!,
                                              albumImage: snapshot
                                                  .data!
                                                  .newReleases![index]
                                                  .album_image,
                                              like: snapshot.data!
                                                  .newReleases![index].like,
                                              pageIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      height: sHeight * 0.2,
                                                      width: sWidth * 0.46,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        coverImage +
                                                            snapshot
                                                                .data!
                                                                .newReleases![
                                                                    index]
                                                                .album_image!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .newReleases![index]
                                                      .title!,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: AppColors.text,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Player.playingSong != null
                                                ? Player.playingSong!.album!
                                                            .id ==
                                                        snapshot
                                                            .data!
                                                            .newReleases![index]
                                                            .id
                                                    ? Icon(
                                                        Icons.bar_chart_rounded,
                                                        color:
                                                            AppColors.primary,
                                                        size: 40,
                                                      )
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          child: Text(
                            "Popular Featured Playlist",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sHeight * 0.25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                snapshot.data!.popularFeaturedPlaylists!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) =>
                                          ViewFeaturedPlaylist(
                                        featuredPlaylistId: snapshot
                                            .data!
                                            .popularFeaturedPlaylists![index]
                                            .id,
                                        title: snapshot
                                            .data!
                                            .popularFeaturedPlaylists![index]
                                            .title!,
                                        featuredPlaylistImage: snapshot
                                            .data!
                                            .popularFeaturedPlaylists![index]
                                            .featured_playlist_image,
                                        like: snapshot
                                            .data!
                                            .popularFeaturedPlaylists![index]
                                            .like,
                                        pageIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image(
                                            height: sHeight * 0.2,
                                            width: sWidth * 0.46,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              featuredPlaylistImage +
                                                  snapshot
                                                      .data!
                                                      .popularFeaturedPlaylists![
                                                          index]
                                                      .featured_playlist_image!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot
                                            .data!
                                            .popularFeaturedPlaylists![index]
                                            .title!,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          child: Text(
                            "Popular Albums",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sHeight * 0.25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.popularAlbums!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => ViewAlbum(
                                        albumId: snapshot
                                            .data!.popularAlbums![index].id,
                                        title: snapshot
                                            .data!.popularAlbums![index].title!,
                                        albumImage: snapshot.data!
                                            .popularAlbums![index].album_image,
                                        like: snapshot
                                            .data!.popularAlbums![index].like,
                                        pageIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                height: sHeight * 0.2,
                                                width: sWidth * 0.46,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  coverImage +
                                                      snapshot
                                                          .data!
                                                          .popularAlbums![index]
                                                          .album_image!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            snapshot.data!.popularAlbums![index]
                                                .title!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: AppColors.text,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Player.playingSong != null
                                          ? Player.playingSong!.album!.id ==
                                                  snapshot.data!
                                                      .popularAlbums![index].id
                                              ? Icon(
                                                  Icons.bar_chart_rounded,
                                                  color: AppColors.primary,
                                                  size: 40,
                                                )
                                              : SizedBox()
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          child: Text(
                            "Popular Artists",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sHeight * 0.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.popularArtists!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => ViewArtist(
                                        artistId: snapshot
                                            .data!.popularArtists![index].id,
                                        pageIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      sHeight * .125),
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
                                                      sHeight * .125),
                                              child: Image(
                                                height: sHeight * 0.25,
                                                width: sHeight * 0.25,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  profileUrl +
                                                      snapshot
                                                          .data!
                                                          .popularArtists![
                                                              index]
                                                          .profile_picture!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            snapshot
                                                .data!
                                                .popularArtists![index]
                                                .profile_name!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: AppColors.text,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Player.playingSong != null
                                          ? Player.playingSong!.album!.artist!
                                                      .id ==
                                                  snapshot.data!
                                                      .popularArtists![index].id
                                              ? Icon(
                                                  Icons.bar_chart_rounded,
                                                  color: AppColors.primary,
                                                  size: 40,
                                                )
                                              : SizedBox()
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        snapshot.data!.smoothPlayerFeaturedPlaylists!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "Featured Playlist",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        snapshot.data!.smoothPlayerFeaturedPlaylists!.isNotEmpty
                            ? GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                                children: List.generate(
                                  snapshot.data!.smoothPlayerFeaturedPlaylists!
                                      .length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) =>
                                                ViewFeaturedPlaylist(
                                              featuredPlaylistId: snapshot
                                                  .data!
                                                  .smoothPlayerFeaturedPlaylists![
                                                      index]
                                                  .id,
                                              title: snapshot
                                                  .data!
                                                  .smoothPlayerFeaturedPlaylists![
                                                      index]
                                                  .title!,
                                              featuredPlaylistImage: snapshot
                                                  .data!
                                                  .smoothPlayerFeaturedPlaylists![
                                                      index]
                                                  .featured_playlist_image,
                                              like: snapshot
                                                  .data!
                                                  .smoothPlayerFeaturedPlaylists![
                                                      index]
                                                  .like,
                                              pageIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                height: sHeight * 0.2,
                                                width: sWidth * 0.46,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  featuredPlaylistImage +
                                                      snapshot
                                                          .data!
                                                          .smoothPlayerFeaturedPlaylists![
                                                              index]
                                                          .featured_playlist_image!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            snapshot
                                                .data!
                                                .smoothPlayerFeaturedPlaylists![
                                                    index]
                                                .title!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
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
      bottomNavigationBar: PageNavigator(pageIndex: 0),
    );
  }
}
