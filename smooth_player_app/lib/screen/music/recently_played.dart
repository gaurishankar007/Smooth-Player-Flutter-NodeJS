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
        child: Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<RecentlyPlayed>>(
                future: recentlyplayed,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        height: sHeight * 0.2,
                                        width: sWidth * 0.46,
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
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data![index].song!.title!,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
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
                })),
      ),
    );
  }
}
