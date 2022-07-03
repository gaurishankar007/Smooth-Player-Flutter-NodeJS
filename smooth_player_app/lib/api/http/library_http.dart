import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/library_res.dart';

import '../log_status.dart';
import '../urls.dart';

class LibraryHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<LibraryData> viewLibrary() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/library"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      return LibraryData.fromJson(jsonDecode(response.body));
    } catch (error) {
      return Future.error(error);
    }
  }
}
