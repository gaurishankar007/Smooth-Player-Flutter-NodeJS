import 'package:flutter/material.dart';
import 'package:smooth_player_app/api/http/recently_played_http.dart';
import 'package:smooth_player_app/api/res/recently_played_res.dart';
import 'package:smooth_player_app/api/urls.dart';

import '../../resource/colors.dart';

class ViewRecentlyPlayed extends StatefulWidget {
  const ViewRecentlyPlayed({Key? key})
      : super(
          key: key,
        );

  @override
  State<ViewRecentlyPlayed> createState() => _ViewRecentlyPlayedState();
}

class _ViewRecentlyPlayedState extends State<ViewRecentlyPlayed> {
  final coverImage = ApiUrls.coverImageUrl;
  late Future<List<RecentlyPlayed>> recentlyplayed;
  // List<RecentlyPlayed> recentlyplayed = [];

  @override
  void initState() {
    super.initState();

    recentlyplayed = RecentlyPlayedHttp().getRecentSong();
  }

  @override
  Widget build(BuildContext context) {
    final sHeight = MediaQuery.of(context).size.height;
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: sWidth * .04,
            right: sWidth * .04,
            top: 10
          ),
        child: FutureBuilder<List<RecentlyPlayed>>(
            future: recentlyplayed,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Text(
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
                                              snapshot.data![index].song!
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            snapshot
                                                .data![index].song!.title!,
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
                                            snapshot
                                                .data![index]
                                                .song!
                                                .album!
                                                .artist!
                                                .profile_name!,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.text,
                                              fontWeight: FontWeight.bold,
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
                                    snapshot.data![index].song!.like!
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
                                ],
                              ),
                            ],
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
                  color: AppColors.primary,
                ),
              );
            }),
      ),
    );
  }
}
