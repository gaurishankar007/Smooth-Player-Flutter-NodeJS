import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import '../res/song_res.dart';
import '../urls.dart';

class LikedSongHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

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
