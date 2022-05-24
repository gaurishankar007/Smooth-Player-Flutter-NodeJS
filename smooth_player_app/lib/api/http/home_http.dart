import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class HomeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> viewHome(String userId) async {
    final response = await get(Uri.parse(routeUrl + "load/home"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }
}
