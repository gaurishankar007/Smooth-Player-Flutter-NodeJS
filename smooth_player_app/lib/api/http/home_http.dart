import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
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
}
