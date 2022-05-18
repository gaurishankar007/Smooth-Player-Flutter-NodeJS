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
}
