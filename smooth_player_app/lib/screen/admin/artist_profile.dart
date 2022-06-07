import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/screen/admin/artist_verification.dart';
import '../../api/http/artist_http.dart';
import '../../api/res/song_res.dart';
import '../../api/res/artist_data_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/admin_navigator.dart';
import '../../widget/song_bar.dart';
import 'admin_view_album.dart';

class ArtistPage extends StatefulWidget {
  final String? artistId;
  final int? pageIndex;
  const ArtistPage({
    Key? key,
    @required this.artistId,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final AudioPlayer player = Player.player;
  Song? song = Player.playingSong;
  final coverImage = ApiUrls.coverImageUrl;
  final profileImage = ApiUrls.profileUrl;
  bool isVerified = false;

  late Future<ArtistData> artistData;

  List<Song> songs = [];

  Future<ArtistData> viewSongs() async {
    ArtistData resData = await ArtistHttp().adminViewArtist(widget.artistId!);
    return resData;
  }

  @override
  void initState() {
    super.initState();

    viewSongs().then((value) {
      songs = value.popularSong!;
      setState(() {
        isVerified = value.artist!.verified!;
      });
    });

    artistData = ArtistHttp().adminViewArtist(widget.artistId!);
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<ArtistData>(
              future: artistData,
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
                                            snapshot
                                                .data!.artist!.profile_picture!,
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
                                  width: sWidth * .7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          snapshot.data!.artist!.profile_name!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          snapshot.data!.artist!.follower!
                                                  .toString() +
                                              " followers",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
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
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Verified",
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                              child: Switch(
                                activeColor: AppColors.primary,
                                value: isVerified,
                                onChanged: (value) async {
                                  final resData = await ArtistHttp()
                                      .verifyArtist(widget.artistId!);
                                  Fluttertoast.showToast(
                                    msg: resData["resM"],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0,
                                  );
                                  setState(() {
                                    isVerified = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      snapshot.data!.popularSong!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Popular",
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
                      snapshot.data!.popularSong!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                right: sWidth * 0.03,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.popularSong!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onDoubleTap: () async {
                                        Song newSong = Song(
                                          id: snapshot
                                              .data!.popularSong![index].id!,
                                          title: snapshot
                                              .data!.popularSong![index].title!,
                                          album: snapshot
                                              .data!.popularSong![index].album!,
                                          music_file: snapshot.data!
                                              .popularSong![index].music_file!,
                                          cover_image: snapshot.data!
                                              .popularSong![index].cover_image!,
                                          like: snapshot
                                              .data!.popularSong![index].like!,
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
                                                          .popularSong![index]
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
                                                                  .popularSong![
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
                                                                .popularSong![
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
                                                                              .popularSong![
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
                                                                .popularSong![
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
                                                                              .popularSong![
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
                                                        .popularSong![index]
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
                                                      Player.songQueue.add(
                                                        Song(
                                                          id: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .id!,
                                                          title: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .title!,
                                                          album: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .album!,
                                                          music_file: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .music_file!,
                                                          cover_image: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .cover_image!,
                                                          like: snapshot
                                                              .data!
                                                              .popularSong![
                                                                  index]
                                                              .like!,
                                                        ),
                                                      );
                                                      Fluttertoast.showToast(
                                                        msg: snapshot
                                                                .data!
                                                                .popularSong![
                                                                    index]
                                                                .title! +
                                                            " is added to the queue.",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 3,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .add_to_queue_rounded,
                                                      color: AppColors.primary,
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
                      snapshot.data!.newAlbum!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "New Releases",
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
                      snapshot.data!.newAlbum!.isNotEmpty
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
                                snapshot.data!.newAlbum!.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => ViewAdminAlbum(
                                            albumId: snapshot
                                                .data!.newAlbum![index].id,
                                            title: snapshot
                                                .data!.newAlbum![index].title!,
                                            albumImage: snapshot.data!
                                                .newAlbum![index].album_image,
                                            like: snapshot
                                                .data!.newAlbum![index].like,
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
                                                            .newAlbum![index]
                                                            .album_image!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              snapshot.data!.newAlbum![index]
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
                                                        .newAlbum![index].id
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
                      snapshot.data!.oldAlbum!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Albums",
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
                      snapshot.data!.oldAlbum!.isNotEmpty
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
                                snapshot.data!.oldAlbum!.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => ViewAdminAlbum(
                                            albumId: snapshot
                                                .data!.oldAlbum![index].id,
                                            title: snapshot
                                                .data!.oldAlbum![index].title!,
                                            albumImage: snapshot.data!
                                                .oldAlbum![index].album_image,
                                            like: snapshot
                                                .data!.oldAlbum![index].like,
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
                                                            .oldAlbum![index]
                                                            .album_image!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              snapshot.data!.oldAlbum![index]
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
                                                        .oldAlbum![index].id
                                                ? Icon(
                                                    Icons.bar_chart_rounded,
                                                    color: Colors.white,
                                                    size: 30,
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
                      snapshot.data!.artist!.biography!.trim().isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "About",
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
                      snapshot.data!.artist!.biography!.trim().isNotEmpty
                          ? Container(
                              padding: EdgeInsets.only(
                                left: sWidth * 0.03,
                                right: sWidth * 0.03,
                              ),
                              child: Text(
                                snapshot.data!.artist!.biography!,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: AppColors.text,
                                  height: 1.5,
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 90,
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
      bottomNavigationBar: AdminPageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
