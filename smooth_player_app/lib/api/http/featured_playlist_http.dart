import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smooth_player_app/api/model/album_model.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist.dart';
import '../log_status.dart';

import '../urls.dart';

class FeaturedPlaylistHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<FeaturedPlaylist>> getFeaturedPlaylist() async {
    final response = await get(
      Uri.parse(routeUrl + "view/featurePlaylist"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resFeaturedPlaylist = jsonDecode(response.body);

    if (resFeaturedPlaylist.isEmpty) {
      return List.empty();
    }

    return resFeaturedPlaylist.map((e) => FeaturedPlaylist.fromJson(e)).toList();
  }

  // Future<Map> deleteAlbum(String albumId) async {
  //   final bearerToken = {
  //     HttpHeaders.authorizationHeader: 'Bearer $token',
  //   };
  //   final response = await delete(Uri.parse(routeUrl + "delete/album"),
  //       body: {"albumId": albumId}, headers: bearerToken);

  //   final responseData = jsonDecode(response.body);

  //   return responseData;
  // }
}
