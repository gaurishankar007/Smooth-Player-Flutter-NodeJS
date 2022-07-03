import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class TokenHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> generateToken(String email, String password) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "generate/token"),
        body: {"email": email, "password": password},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body)
      };
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Map> verifyToken(String tokenNumber, String userId) async {
    try {
      final response = await put(
        Uri.parse(routeUrl + "verify/token"),
        body: {"tokenNumber": tokenNumber, "userId": userId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body)
      };
    } catch (error) {
      return Future.error(error);
    }
  }
}
