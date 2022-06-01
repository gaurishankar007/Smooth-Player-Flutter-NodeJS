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
    final response = await get(Uri.parse(routeUrl + "load/home"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return HomeData.fromJson(jsonDecode(response.body));
  }

  Future<List<FeaturedPlaylist>> getFeaturedPlaylists() async {
    final response =
        await post(Uri.parse(routeUrl + "get/featuredPlaylists"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    List resData = jsonDecode(response.body);

    List<FeaturedPlaylist> a =
        resData.map((e) => FeaturedPlaylist.fromJson(e)).toList();
    print(a) ;
    return a;
  }

  Future<List<FeaturedPlaylist>> getFeaturedPlaylists1(
      List<String> featuredPlaylistIds) async {
    Map<String, String> data = {};

    final response = await post(Uri.parse(routeUrl + "get/featuredPlaylists"),
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        });

    List resData = jsonDecode(response.body);

    return resData.map((e) => FeaturedPlaylist.fromJson(e)).toList();
  }
}
