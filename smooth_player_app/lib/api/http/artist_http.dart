import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/artist_data_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';

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

  Future<List<Artist>> searchArtist(String profileName) async {
    final response = await post(
      Uri.parse(routeUrl + "search/artist"),
      body: {"profile_name": profileName},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    List resSearch = jsonDecode(response.body);
    return resSearch.map((e) => Artist.fromJson(e)).toList();
  }

  Future<List<Artist>> searchPopularArtist() async {
    final response = await get(
      Uri.parse(routeUrl + "view/popularArtist"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    List resSearch = jsonDecode(response.body);
    return resSearch.map((e) => Artist.fromJson(e)).toList();
  }

  Future<ArtistData> adminViewArtist(String artistId) async {
    final response =
        await post(Uri.parse(routeUrl + "admin/artistProfile"), body: {
      "artistId": artistId
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return ArtistData.fromJson(jsonDecode(response.body));
  }

  Future<Map> verifyArtist(String artistId) async {
    final response = await put(Uri.parse(routeUrl + "verify/artist"), body: {
      "artistId": artistId
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }
}
