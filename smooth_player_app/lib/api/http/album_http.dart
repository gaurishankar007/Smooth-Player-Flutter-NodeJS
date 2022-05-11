import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/urls.dart';

class AlbumHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;
  Future<List<Album>> getAlbums() async {
    final response = await get(
      Uri.parse(routeUrl + "view/album"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resAlbum = jsonDecode(response.body);

    if (resAlbum.isEmpty) {
      return List.empty();
    }

    return resAlbum.map((e) => Album.fromJson(e)).toList();
  }
}
