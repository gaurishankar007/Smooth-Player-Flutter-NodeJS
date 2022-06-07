import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../log_status.dart';
import '../res/song_res.dart';
import '../urls.dart';

class LikeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> likeSong(String songId) async {
    final response = await post(Uri.parse(routeUrl + "like/song"), body: {
      "songId": songId,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkSongLike(String songId) async {
    final response = await post(
      Uri.parse(routeUrl + "like/checkSong"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }

  Future<List<Song>> viewLikedSongs() async {
    final response = await get(
      Uri.parse(routeUrl + "view/likedSongs"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resLikedSongs = jsonDecode(response.body);

    if (resLikedSongs.isEmpty) {
      return List.empty();
    }

    List<Song> likedSong = [];

    for (int i = 0; i < resLikedSongs.length; i++) {
      likedSong.add(Song.fromJson(resLikedSongs[i]["song"]));
    }

    return likedSong;
  }
}
