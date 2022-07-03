import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/api/res/search_song_res.dart';
import 'package:smooth_player_app/screen/view/view_user.dart';

import '../api/res/song_res.dart';
import '../api/urls.dart';
import '../resource/colors.dart';
import '../resource/genre.dart';
import '../resource/player.dart';
import '../widget/navigator.dart';
import '../widget/song_bar.dart';
import 'view/view_album.dart';
import 'view/view_artist.dart';
import 'view/view_featured_playlist.dart';
import 'view/view_genre.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final AudioPlayer player = Player.player;
  final coverImage = ApiUrls.coverImageUrl;
  final profileUrl = ApiUrls.profileUrl;
  final featuredPlaylistImage = ApiUrls.featuredPlaylistUrl;
  final genreUrl = ApiUrls.genreUrl;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  bool searching = false;
  late Future<SearchData> searchResult;

  @override
  void initState() {
    super.initState();
    stateSub = player.onPlayerStateChanged.listen((state) {
      setState(() {
        songBarVisibility = Player.isPlaying;
      });
    });
    searchResult = SongHttp().searchSong("");
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
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            top: 10,
            bottom: 80,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: ((value) {
                  if (value.trim().isEmpty) {
                    setState(() {
                      searching = false;
                    });
                  } else {
                    setState(() {
                      searching = true;
                      searchResult = SongHttp().searchSong(value);
                    });
                  }
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Search songs",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              searching
                  ? FutureBuilder<SearchData>(
                      future: searchResult,
                      builder: ((context, snapshot) {
                        List<Widget> children = [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          children = <Widget>[
                            Container(
                              width: sWidth * 0.97,
                              height: sHeight * .9,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: AppColors.primary,
                              ),
                            )
                          ];
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {}
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data!.songs!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Songs",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                snapshot.data!.songs!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          left: sWidth * 0.03,
                                          right: sWidth * 0.03,
                                        ),
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data!.songs!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              child: GestureDetector(
                                                onDoubleTap: () async {
                                                  Song newSong = Song(
                                                    id: snapshot.data!
                                                        .songs![index].id!,
                                                    title: snapshot.data!
                                                        .songs![index].title!,
                                                    album: snapshot.data!
                                                        .songs![index].album!,
                                                    music_file: snapshot
                                                        .data!
                                                        .songs![index]
                                                        .music_file!,
                                                    cover_image: snapshot
                                                        .data!
                                                        .songs![index]
                                                        .cover_image!,
                                                    like: snapshot.data!
                                                        .songs![index].like!,
                                                  );

                                                  Player().playSong(
                                                      newSong, [newSong]);
                                                },
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Player.playingSong != null
                                                        ? Player.playingSong!
                                                                    .id ==
                                                                snapshot
                                                                    .data!
                                                                    .songs![
                                                                        index]
                                                                    .id!
                                                            ? Icon(
                                                                Icons
                                                                    .bar_chart_rounded,
                                                                color: AppColors
                                                                    .primary,
                                                              )
                                                            : Text(
                                                                "${index + 1}",
                                                                style:
                                                                    TextStyle(
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    spreadRadius:
                                                                        1,
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        Offset(
                                                                            2,
                                                                            2),
                                                                  )
                                                                ],
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      NetworkImage(
                                                                    coverImage +
                                                                        snapshot
                                                                            .data!
                                                                            .songs![index]
                                                                            .cover_image!,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  sWidth * .35,
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
                                                                          .songs![
                                                                              index]
                                                                          .title!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      softWrap:
                                                                          false,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Player.playingSong !=
                                                                                null
                                                                            ? Player.playingSong!.id == snapshot.data!.songs![index].id!
                                                                                ? AppColors.primary
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
                                                                          .songs![
                                                                              index]
                                                                          .album!
                                                                          .title!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      softWrap:
                                                                          false,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Player.playingSong !=
                                                                                null
                                                                            ? Player.playingSong!.id == snapshot.data!.songs![index].id!
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
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data!
                                                                  .songs![index]
                                                                  .like!
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .text,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons.favorite,
                                                              color: AppColors
                                                                  .primary,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            IconButton(
                                                              constraints:
                                                                  BoxConstraints(),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      SimpleDialog(
                                                                    children: [
                                                                      SimpleDialogOption(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              75,
                                                                        ),
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                AppColors.primary,
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(ctx).pop();

                                                                            Player.songQueue.add(
                                                                              Song(
                                                                                id: snapshot.data!.songs![index].id!,
                                                                                title: snapshot.data!.songs![index].title!,
                                                                                album: snapshot.data!.songs![index].album!,
                                                                                music_file: snapshot.data!.songs![index].music_file!,
                                                                                cover_image: snapshot.data!.songs![index].cover_image!,
                                                                                like: snapshot.data!.songs![index].like!,
                                                                              ),
                                                                            );
                                                                            Fluttertoast.showToast(
                                                                              msg: snapshot.data!.songs![index].title! + " is added to the queue.",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 3,
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text("Add to queue"),
                                                                        ),
                                                                      ),
                                                                      SimpleDialogOption(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              75,
                                                                        ),
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                AppColors.primary,
                                                                            elevation:
                                                                                10,
                                                                            shadowColor:
                                                                                Colors.black,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text("Add to playlist"),
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
                                snapshot.data!.artists!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Artists",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                snapshot.data!.artists!.isNotEmpty
                                    ? SizedBox(
                                        height: sHeight * .25,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              snapshot.data!.artists!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (builder) =>
                                                        ViewArtist(
                                                      artistId: snapshot.data!
                                                          .artists![index].id,
                                                      pageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        sHeight *
                                                                            .1),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    2, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        sHeight *
                                                                            .1),
                                                            child: Image(
                                                              height:
                                                                  sHeight * 0.2,
                                                              width:
                                                                  sHeight * 0.2,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                profileUrl +
                                                                    snapshot
                                                                        .data!
                                                                        .artists![
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
                                                              .artists![index]
                                                              .profile_name!,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.text,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Player.playingSong != null
                                                        ? Player
                                                                    .playingSong!
                                                                    .album!
                                                                    .artist!
                                                                    .id ==
                                                                snapshot
                                                                    .data!
                                                                    .artists![
                                                                        index]
                                                                    .id
                                                            ? Icon(
                                                                Icons
                                                                    .bar_chart_rounded,
                                                                color: AppColors
                                                                    .primary,
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
                                snapshot.data!.albums!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Albums",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                snapshot.data!.albums!.isNotEmpty
                                    ? SizedBox(
                                        height: sHeight * .25,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              snapshot.data!.albums!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (builder) =>
                                                        ViewAlbum(
                                                      albumId: snapshot.data!
                                                          .albums![index].id,
                                                      title: snapshot
                                                          .data!
                                                          .albums![index]
                                                          .title!,
                                                      albumImage: snapshot
                                                          .data!
                                                          .albums![index]
                                                          .album_image,
                                                      pageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    2, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Image(
                                                              height:
                                                                  sHeight * 0.2,
                                                              width:
                                                                  sWidth * 0.46,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                coverImage +
                                                                    snapshot
                                                                        .data!
                                                                        .albums![
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
                                                              .albums![index]
                                                              .title!,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.text,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Player.playingSong != null
                                                        ? Player.playingSong!
                                                                    .album!.id ==
                                                                snapshot
                                                                    .data!
                                                                    .albums![
                                                                        index]
                                                                    .id
                                                            ? Icon(
                                                                Icons
                                                                    .bar_chart_rounded,
                                                                color: AppColors
                                                                    .primary,
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
                                snapshot.data!.featuredPlaylists!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Featured Playlists",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                snapshot.data!.featuredPlaylists!.isNotEmpty
                                    ? SizedBox(
                                        height: sHeight * 0.25,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot
                                              .data!.featuredPlaylists!.length,
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
                                                          .featuredPlaylists![
                                                              index]
                                                          .id,
                                                      title: snapshot
                                                          .data!
                                                          .featuredPlaylists![
                                                              index]
                                                          .title!,
                                                      featuredPlaylistImage: snapshot
                                                          .data!
                                                          .featuredPlaylists![
                                                              index]
                                                          .featured_playlist_image,
                                                      pageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            spreadRadius: 1,
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(2, 2),
                                                          )
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image(
                                                          height: sHeight * 0.2,
                                                          width: sWidth * 0.46,
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            featuredPlaylistImage +
                                                                snapshot
                                                                    .data!
                                                                    .featuredPlaylists![
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
                                                          .featuredPlaylists![
                                                              index]
                                                          .title!,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                snapshot.data!.users!.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Users",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                snapshot.data!.users!.isNotEmpty
                                    ? SizedBox(
                                        height: sHeight * .25,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              snapshot.data!.users!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (builder) =>
                                                        ViewUser(
                                                      userId: snapshot.data!
                                                          .users![index].id,
                                                      pageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        sHeight *
                                                                            .1),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    2, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        sHeight *
                                                                            .1),
                                                            child: Image(
                                                              height:
                                                                  sHeight * 0.2,
                                                              width:
                                                                  sHeight * 0.2,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                profileUrl +
                                                                    snapshot
                                                                        .data!
                                                                        .users![
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
                                                              .users![index]
                                                              .profile_name!,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.text,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Player.playingSong != null
                                                        ? Player
                                                                    .playingSong!
                                                                    .album!
                                                                    .artist!
                                                                    .id ==
                                                                snapshot
                                                                    .data!
                                                                    .users![
                                                                        index]
                                                                    .id
                                                            ? Icon(
                                                                Icons
                                                                    .bar_chart_rounded,
                                                                color: AppColors
                                                                    .primary,
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
                              ],
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          if ("${snapshot.error}".split("Exception: ")[0] ==
                              "Socket") {
                            children = <Widget>[
                              Container(
                                width: sWidth,
                                height: sHeight * .9,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.warning_rounded,
                                      size: 25,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Connection Problem",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ];
                          } else {
                            children = <Widget>[
                              Container(
                                width: sWidth,
                                height: sHeight * .9,
                                alignment: Alignment.center,
                                child: Text(
                                  "${snapshot.error}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ];
                          }
                        }
                        return Column(
                          children: children,
                        );
                      }),
                    )
                  : FutureBuilder<List>(
                      future: SongHttp().searchGenre(),
                      builder: ((context, snapshot) {
                        List<Widget> children = [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          children = <Widget>[
                            Container(
                              width: sWidth * 0.97,
                              height: sHeight * .9,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: AppColors.primary,
                              ),
                            )
                          ];
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: Text(
                                      "Browse Song Genres",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio:
                                    (sWidth - (sWidth * .58)) / (sHeight * .25),
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => ViewGenre(
                                              genre: snapshot.data![index],
                                              pageIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              Container(
                                                height: sHeight * 0.25,
                                                width: sWidth * 0.46,
                                                decoration: BoxDecoration(
                                                  color: SongGenreColors
                                                          .colorList[
                                                      MusicGenre.musicGenres
                                                          .indexOf(snapshot
                                                              .data![index])],
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
                                                width: sHeight * 0.25,
                                                child: Text(
                                                  snapshot.data![index],
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                            ),
                                            child: Image(
                                              height: sHeight * 0.13,
                                              width: sHeight * 0.16,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(genreUrl +
                                                  snapshot.data![index] +
                                                  ".jpg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ];
                          } else if (snapshot.hasError) {
                            if ("${snapshot.error}".split("Exception: ")[0] ==
                                "Socket") {
                              children = <Widget>[
                                Container(
                                  width: sWidth,
                                  height: sHeight * .9,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Connection Problem",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ];
                            } else {
                              children = <Widget>[
                                Container(
                                  width: sWidth,
                                  height: sHeight * .9,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${snapshot.error}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ];
                            }
                          }
                        }
                        return Column(
                          children: children,
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
      bottomNavigationBar: PageNavigator(pageIndex: 1),
    );
  }
}
