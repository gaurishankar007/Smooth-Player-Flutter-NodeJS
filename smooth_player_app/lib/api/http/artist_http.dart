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
    try {
      final response =
          await post(Uri.parse(routeUrl + "view/artistProfile"), body: {
        "artistId": artistId
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return ArtistData.fromJson(jsonDecode(response.body));
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Artist>> searchArtist(String profileName) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "search/artist"),
        body: {"profile_name": profileName},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      List resSearch = jsonDecode(response.body);
      return resSearch.map((e) => Artist.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Artist>> searchPopularArtist() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/popularArtist"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      List resSearch = jsonDecode(response.body);
      return resSearch.map((e) => Artist.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<ArtistData> adminViewArtist(String artistId) async {
    try {
      final response =
          await post(Uri.parse(routeUrl + "admin/artistProfile"), body: {
        "artistId": artistId
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return ArtistData.fromJson(jsonDecode(response.body));
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Map> verifyArtist(String artistId) async {
    try {
      final response = await put(Uri.parse(routeUrl + "verify/artist"), body: {
        "artistId": artistId
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return jsonDecode(response.body) as Map;
    } catch (error) {
      return Future.error(error);
    }
  }
}
