import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class TokentHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> generateTokem(String email, String password) async {
    final response = await post(
      Uri.parse(routeUrl + "generate/token"),
      body: {"email": email, "password": password},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> verifyToken(String tokenNumber, String userId) async {
    final response = await put(
      Uri.parse(routeUrl + "verify/token"),
      body: {"tokenNumber": tokenNumber, "userId": userId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }
}
