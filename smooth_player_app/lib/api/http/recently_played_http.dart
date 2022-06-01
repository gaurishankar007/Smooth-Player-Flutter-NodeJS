import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/recently_played_res.dart';

import '../log_status.dart';
import '../urls.dart';

class RecentlyPlayedHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> addRecentSong(String songId) async {
    final response = await post(
      Uri.parse(routeUrl + "add/recentSong"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return responseData;
  }

  Future<List<RecentlyPlayed>> getRecentSong() async {
    final response = await get(
      Uri.parse(routeUrl + "view/recentSong"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);

    List<RecentlyPlayed> recentlyPlayedSongs = [];
    for (int i = 0; i < responseData.length; i++) {
      recentlyPlayedSongs.add(RecentlyPlayed.fromJson(responseData[i]));
    }

    return recentlyPlayedSongs;
  }
}
