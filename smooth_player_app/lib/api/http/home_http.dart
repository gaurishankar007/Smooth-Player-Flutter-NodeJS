import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/api/res/home_res.dart';

import '../log_status.dart';
import '../urls.dart';

class HomeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<HomeData> viewHome() async {
    try {
      final response = await get(Uri.parse(routeUrl + "load/home"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return HomeData.fromJson(jsonDecode(response.body));
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<FeaturedPlaylist>> getFeaturedPlaylists(
      int featuredPlaylistNum) async {
    try {
      final response =
          await post(Uri.parse(routeUrl + "get/featuredPlaylists"), body: {
        "featuredPlaylistNum": featuredPlaylistNum.toString()
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      List resData = jsonDecode(response.body);

      return resData.map((e) => FeaturedPlaylist.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }
}
