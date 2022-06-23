import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../log_status.dart';
import '../urls.dart';

class FollowHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> followArtist(String artistId, String artistName) async {
    final response = await post(Uri.parse(routeUrl + "follow/artist"), body: {
      "artistId": artistId,
      "artistName": artistName
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<bool> checkFollow(String artistId) async {
    final response = await post(
      Uri.parse(routeUrl + "follow/checkArtist"),
      body: {"artistId": artistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }
}
