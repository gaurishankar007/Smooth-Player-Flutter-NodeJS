import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';
import 'package:smooth_player_app/api/urls.dart';

class SongHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<Song>> getSongs(String albumId) async {
    final response = await post(
      Uri.parse(routeUrl + "view/song"),
      body: {"albumId": albumId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resSong = jsonDecode(response.body);

    if (resSong.isEmpty) {
      return List.empty();
    }

    return resSong.map((e) => Song.fromJson(e)).toList();
  }
}
