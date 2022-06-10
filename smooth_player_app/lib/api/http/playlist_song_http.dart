import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/playlist_song_res.dart';

import '../log_status.dart';
import '../urls.dart';

class PlaylistSongHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> addPlaylistSong(String playlistId, String songId) async {
    final response = await post(
      Uri.parse(routeUrl + "add/playlistSong"),
      body: {"playlistId": playlistId, "songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> deletePlaylistSong(String playlistSongId) async {
    final response = await delete(
      Uri.parse(routeUrl + "delete/playlistSong"),
      body: {"playlistSongId": playlistSongId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<List<PlaylistSong>> viewPlaylistSongs(String playlistId) async {
    final response = await post(
      Uri.parse(routeUrl + "playlist/songs"),
      body: {"playlistId": playlistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resData = jsonDecode(response.body);

    return resData.map((e) => PlaylistSong.fromJson(e)).toList();
  }
}
