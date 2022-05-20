import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smooth_player_app/api/model/featured_playlist_model.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import '../log_status.dart';

import '../model/featured_playlist_model.dart';
import '../urls.dart';

class FeaturedPlaylistHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<FeaturedPlaylist>> getFeaturedPlaylist() async {
    final response = await get(
      Uri.parse(routeUrl + "view/featuredPlaylist"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resFeaturedPlaylist = jsonDecode(response.body);

    if (resFeaturedPlaylist.isEmpty) {
      return List.empty();
    }

    return resFeaturedPlaylist
        .map((e) => FeaturedPlaylist.fromJson(e))
        .toList();
  }

  Future<Map> createFeaturedPlaylist(FeaturedPlaylistModel playlistData) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(routeUrl + "upload/featuredPlaylist"));

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      Map<String, String> playlistDetail = {
        "title": "${playlistData.playlistTitle}",
      };
      request.fields.addAll(playlistDetail);

      List<MultipartFile> multipartList = [];
      multipartList.add(http.MultipartFile(
        'featured_playlist_image',
        playlistData.cover_image!.readAsBytes().asStream(),
        playlistData.cover_image!.lengthSync(),
        filename: playlistData.cover_image!.path.split('/').last,
      ));

      request.files.addAll(multipartList);
      final response = await request.send();
      var responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString) as Map;
      return {
        "statusCode": response.statusCode,
        "body": responseData,
      };
    } catch (err) {
      log('$err');
    }
    return {
      "body": {"resM": "error occurred"},
      "statusCode": 400,
    };
  }

Future<Map> deleteFeaturedPlaylist(String featuredPlaylistId) async {
    final bearerToken = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    
    final response = await delete(Uri.parse(routeUrl + "delete/featuredPlaylist"),
        body: {"featuredPlaylistId": featuredPlaylistId}, headers: bearerToken);

    final responseData = jsonDecode(response.body);
    return responseData;
  }

  Future<List<FeaturedPlaylist>> searchPlaylist(String title) async {
    final response = await post(
      Uri.parse(routeUrl + "search/featuredPlaylist"),
      body: {"title": title},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    List resSearchPlaylist = jsonDecode(response.body);
    return resSearchPlaylist.map((e) => FeaturedPlaylist.fromJson(e)).toList();
  }
}
