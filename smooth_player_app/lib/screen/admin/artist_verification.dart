import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/artist_http.dart';

import '../../api/res/artist_res.dart';
import '../../api/urls.dart';
import '../../resource/colors.dart';
import '../../resource/player.dart';
import '../../widget/admin_navigator.dart';
import '../../widget/song_bar.dart';
import 'artist_profile.dart';

class VerifyArtist extends StatefulWidget {
  const VerifyArtist({Key? key}) : super(key: key);

  @override
  State<VerifyArtist> createState() => _VerifyArtistState();
}

class _VerifyArtistState extends State<VerifyArtist> {
  final AudioPlayer player = Player.player;
  final profileImage = ApiUrls.profileUrl;

  late StreamSubscription stateSub;

  bool songBarVisibility = Player.isPlaying;

  late Future<List<Artist>> artistList;

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

    artistList = ArtistHttp().searchPopularArtist();

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
            left: sWidth * 0.03,
            right: sWidth * 0.03,
            top: 20,
          ),
          child: Column(
            children: [
              TextFormField(
                onChanged: ((value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      artistList = ArtistHttp().searchArtist(value);
                    });
                  } else {
                    setState(() {
                      artistList = ArtistHttp().searchPopularArtist();
                    });
                  }
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Search Artists",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<List<Artist>>(
                future: artistList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio:
                          (sWidth - (sWidth * .64)) / (sHeight * .25),
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ArtistPage(
                                    artistId: snapshot.data![index].id,
                                    pageIndex: 1,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
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
                                        borderRadius: BorderRadius.circular(
                                            sHeight * 0.125),
                                        child: Image(
                                          height: sHeight * 0.167,
                                          width: sHeight * 0.167,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            profileImage +
                                                snapshot.data![index]
                                                    .profile_picture!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data![index].profile_name!,
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
                                    ? Player.playingSong!.album!.artist!.id ==
                                            snapshot.data![index].id
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
      bottomNavigationBar: AdminPageNavigator(pageIndex: 1),
    );
  }
}
