import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/urls.dart';

class FollowedArtistHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<Artist>> viewFollowedArtist() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/followedArtists"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      List responseData = jsonDecode(response.body);

      List<Artist> followedArtists = [];

      for (int i = 0; i < responseData.length; i++) {
        followedArtists.add(Artist.fromJson(responseData[i]["artist"]));
      }

      return followedArtists;
    } catch (error) {
      return Future.error(error);
    }
  }
}
