import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/urls.dart';

class FeaturedPlaylistHTTP {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

    Future<Map> deleteFeaturedAlbum(String albumId) async {
    final bearerToken = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    final response = await delete(Uri.parse(routeUrl + "delete/featuredalbum"),
        body: {"albumId": albumId}, headers: bearerToken);

    final responseData = jsonDecode(response.body);

    return responseData;
  }
}


