import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../log_status.dart';
import '../urls.dart';

class LikeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> likeSong(String songId) async {
    final response = await post(Uri.parse(routeUrl + "/like/song"), body: {
      "songId": songId,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkSongLike(String songId) async {
    final response = await post(
      Uri.parse(routeUrl + "like/checkSong"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }
}
