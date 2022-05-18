import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/res/featured_song_res.dart';
import '../urls.dart';

class FeaturedSongHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<FeaturedSong>> getFeaturedSongs(String featuredPlaylistId) async {
    final response = await post(
      Uri.parse(routeUrl + "view/featuredSong"),
      body: {"featuredPlaylistId": featuredPlaylistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resFeaturedSongs = jsonDecode(response.body);

    if (resFeaturedSongs.isEmpty) {
      return List.empty();
    }

    return resFeaturedSongs.map((e) => FeaturedSong.fromJson(e)).toList();
  }

  Future<Map> addFeaturedSongs(
      String featuredPlaylistId, List<String> songs) async {
    Map<String, dynamic> songsId = {
      "featuredPlaylistId": featuredPlaylistId,
    };

    for (int i = 0; i < songs.length; i++) {
      songsId["songId[$i]"] = songs[i];
    }

    final response = await post(
      Uri.parse(routeUrl + "upload/featuredSong"),
      body: songsId,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body) as Map,
    };
  }
}
