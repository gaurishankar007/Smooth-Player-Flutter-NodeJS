import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/user_http.dart';
import 'package:smooth_player_app/api/res/user_data_res.dart';
import 'package:smooth_player_app/screen/view/view_featured_playlist.dart';

import '../../api/res/song_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/navigator.dart';
import '../../widget/song_bar.dart';
import '../library/add_playlist_song.dart';
import 'view_album.dart';
import 'view_artist.dart';
import 'view_user_playlist.dart';

class ViewUser extends StatefulWidget {
  final String? userId;
  final int? pageIndex;
  const ViewUser({
    Key? key,
    @required this.userId,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  final AudioPlayer player = Player.player;
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;
  final profileImage = ApiUrls.profileUrl;

  List<Song> songs = [];

  late Future<UserData> userData;

  late StreamSubscription stateSub;

  void userPublishedData() async {
    userData = UserHttp().userPublishedData(widget.userId!);
    UserData resData = await userData;
    songs = resData.likedSongs!;
  }

  @override
  void initState() {
    super.initState();

    userPublishedData();

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
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<UserData>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    child: Image(
                                      width: sWidth,
                                      height: sHeight * .35,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        profileImage +
                                            snapshot.data!.profile!
                                                .profile_picture!,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: sWidth,
                                    height: sHeight * .35,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black38,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: sWidth * 0.015,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: sWidth * .75,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      snapshot.data!.profile!.profile_name!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: sWidth * 0.03,
                          right: sWidth * 0.03,
                          top: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Gender: ",
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.profile!.gender!,
                                      style: TextStyle(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Birth Date: ",
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.profile!.birth_date!
                                          .split("T")[0],
                                      style: TextStyle(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Biography:",
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: sWidth * .9,
                              child: Text(
                                snapshot.data!.profile!.biography!,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                                style: TextStyle(
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      snapshot.data!.likedSongs!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 20,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Liked Songs",
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedSongs!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                right: sWidth * 0.03,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.likedSongs!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onDoubleTap: () async {
                                        Song newSong = Song(
                                          id: snapshot
                                              .data!.likedSongs![index].id!,
                                          title: snapshot
                                              .data!.likedSongs![index].title!,
                                          album: snapshot
                                              .data!.likedSongs![index].album!,
                                          music_file: snapshot.data!
                                              .likedSongs![index].music_file!,
                                          cover_image: snapshot.data!
                                              .likedSongs![index].cover_image!,
                                          like: snapshot
                                              .data!.likedSongs![index].like!,
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
                                                      snapshot
                                                          .data!
                                                          .likedSongs![index]
                                                          .id!
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
                                                              8),
                                                      child: Image(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          coverImage +
                                                              snapshot
                                                                  .data!
                                                                  .likedSongs![
                                                                      index]
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .likedSongs![
                                                                    index]
                                                                .title!,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            softWrap: false,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Player
                                                                          .playingSong !=
                                                                      null
                                                                  ? Player.playingSong!
                                                                              .id ==
                                                                          snapshot
                                                                              .data!
                                                                              .likedSongs![
                                                                                  index]
                                                                              .id!
                                                                      ? AppColors
                                                                          .primary
                                                                      : AppColors
                                                                          .text
                                                                  : AppColors
                                                                      .text,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                                .likedSongs![
                                                                    index]
                                                                .album!
                                                                .title!,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            softWrap: false,
                                                            style: TextStyle(
                                                              color: Player
                                                                          .playingSong !=
                                                                      null
                                                                  ? Player.playingSong!
                                                                              .id ==
                                                                          snapshot
                                                                              .data!
                                                                              .likedSongs![
                                                                                  index]
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
                                              Row(
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .likedSongs![index]
                                                        .like!
                                                        .toString(),
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
                                                    constraints:
                                                        BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            SimpleDialog(
                                                          children: [
                                                            SimpleDialogOption(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 75,
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                      AppColors
                                                                          .primary,
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop();

                                                                  Player
                                                                      .songQueue
                                                                      .add(
                                                                    Song(
                                                                      id: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .id!,
                                                                      title: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .title!,
                                                                      album: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .album!,
                                                                      music_file: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .music_file!,
                                                                      cover_image: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .cover_image!,
                                                                      like: snapshot
                                                                          .data!
                                                                          .likedSongs![
                                                                              index]
                                                                          .like!,
                                                                    ),
                                                                  );
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: snapshot
                                                                            .data!
                                                                            .likedSongs![index]
                                                                            .title! +
                                                                        " is added to the queue.",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .BOTTOM,
                                                                    timeInSecForIosWeb:
                                                                        3,
                                                                  );
                                                                },
                                                                child: Text(
                                                                    "Add to queue"),
                                                              ),
                                                            ),
                                                            SimpleDialogOption(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 75,
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                      AppColors
                                                                          .primary,
                                                                  elevation: 10,
                                                                  shadowColor:
                                                                      Colors
                                                                          .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (builder) =>
                                                                              AddSongToPlaylist(
                                                                        songId: snapshot
                                                                            .data!
                                                                            .likedSongs![index]
                                                                            .id,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                    "Add to playlist"),
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
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.followedArtists!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 20,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Followed Artists",
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedAlbums!.isNotEmpty
                          ? GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio:
                                  (sWidth - (sWidth * .64)) / (sHeight * .25),
                              crossAxisSpacing: 10,
                              crossAxisCount: 3,
                              children: List.generate(
                                snapshot.data!.followedArtists!.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => ViewArtist(
                                            artistId: snapshot.data!
                                                .followedArtists![index].id,
                                            pageIndex: 1,
                                          ),
                                        ),
                                      );
                                    },
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
                                                        sHeight * 0.125),
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
                                                        sHeight * 0.125),
                                                child: Image(
                                                  height: sHeight * 0.167,
                                                  width: sHeight * 0.167,
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    profileImage +
                                                        snapshot
                                                            .data!
                                                            .followedArtists![
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
                                                  .followedArtists![index]
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
                                                    snapshot
                                                        .data!
                                                        .followedArtists![index]
                                                        .id
                                                ? Icon(
                                                    Icons.bar_chart_rounded,
                                                    color: AppColors.primary,
                                                    size: 40,
                                                  )
                                                : SizedBox()
                                            : SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedAlbums!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Liked Albums",
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedAlbums!.isNotEmpty
                          ? GridView.count(
                              padding: EdgeInsets.only(
                                left: sWidth * .03,
                                right: sWidth * .03,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio:
                                  (sWidth - (sWidth * .55)) / (sHeight * .25),
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: List.generate(
                                snapshot.data!.likedAlbums!.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => ViewAlbum(
                                            albumId: snapshot
                                                .data!.likedAlbums![index].id,
                                            title: snapshot.data!
                                                .likedAlbums![index].title!,
                                            albumImage: snapshot
                                                .data!
                                                .likedAlbums![index]
                                                .album_image,
                                            pageIndex: widget.pageIndex,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                            .likedAlbums![index]
                                                            .album_image!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              snapshot.data!.likedAlbums![index]
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
                                                        .likedAlbums![index].id
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
                            )
                          : SizedBox(),
                      snapshot.data!.likedFeaturedPlaylists!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Liked Featured Playlists",
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedFeaturedPlaylists!.isNotEmpty
                          ? GridView.count(
                              padding: EdgeInsets.only(
                                left: sWidth * .03,
                                right: sWidth * .03,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio:
                                  (sWidth - (sWidth * .55)) / (sHeight * .25),
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: List.generate(
                                snapshot.data!.likedFeaturedPlaylists!.length,
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
                                                .likedFeaturedPlaylists![index]
                                                .id,
                                            title: snapshot
                                                .data!
                                                .likedFeaturedPlaylists![index]
                                                .title!,
                                            featuredPlaylistImage: snapshot
                                                .data!
                                                .likedFeaturedPlaylists![index]
                                                .featured_playlist_image,
                                            pageIndex: widget.pageIndex,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                        .likedFeaturedPlaylists![
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
                                              .likedFeaturedPlaylists![index]
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
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.playlists!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 20,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Playlists",
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      snapshot.data!.likedSongs!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                right: sWidth * 0.03,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.playlists!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) =>
                                                UserPlaylistSong(
                                              playlistId: snapshot
                                                  .data!.playlists![index].id,
                                              playlistTitle: snapshot.data!
                                                  .playlists![index].title,
                                            ),
                                          ),
                                        );
                                      },
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .playlists![index]
                                                        .title!,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.text,
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
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 80,
                      ),
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
