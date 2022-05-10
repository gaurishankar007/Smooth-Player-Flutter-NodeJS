import 'dart:convert';

import 'package:http/http.dart';

import '../../api/urls.dart';

class LoginHttp {
  final routeUrl = ApiUrls.routeUrl;

  Future<Map> signup(String username, String password, String email, String id,
      String gender) async {
    Map<String, String> userData = {
      "username": username,
      "password": password,
    };

    final response =
        await post(Uri.parse(routeUrl + "user/login"), body: userData);
    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body) as Map,
    };
  }
}
