import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/artist_data_res.dart';

import '../log_status.dart';
import '../urls.dart';

class ArtistHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<ArtistData> viewArtist(String artistId) async {
    final response =
        await post(Uri.parse(routeUrl + "view/artistProfile"), body: {
      "artistId": artistId
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return ArtistData.fromJson(jsonDecode(response.body));
  }
}
