import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/playlist_res.dart';

import '../log_status.dart';
import '../urls.dart';

class PlaylistHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> addPlaylist(String title) async {
    final response = await post(
      Uri.parse(routeUrl + "create/playlist"),
      body: {"title": title},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<List<Playlist>> viewPlaylists() async {
    final response = await get(
      Uri.parse(routeUrl + "view/playlists"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resData = jsonDecode(response.body);

    return resData.map((e) => Playlist.fromJson(e)).toList();
  }

  Future<Map> renamePlaylist(String playlistId, String playlistTitle) async {
    final response = await put(
      Uri.parse(routeUrl + "rename/playlist"),
      body: {"playlistTitle": playlistTitle, "playlistId": playlistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> deletePlaylist(String playlistId, String playlistTitle) async {
    final response = await delete(
      Uri.parse(routeUrl + "delete/playlist"),
      body: {"playlistTitle": playlistTitle, "playlistId": playlistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }
}
