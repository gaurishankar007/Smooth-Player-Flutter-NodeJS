// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../log_status.dart';
import '../model/user_model.dart';
import '../urls.dart';

class UserHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> changePassword(String currentPassword, String newPassword) async {
    Map<String, String> userData = {
      "currPassword": currentPassword,
      "newPassword": newPassword,
    };

    final response = await put(
      Uri.parse(routeUrl + "user/changePassword"),
      body: userData,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body) as Map,
    };
  }

  Future<User> getUser() async {
    final response = await get(
      Uri.parse(routeUrl + "user/view"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return User.fromJson(jsonDecode(response.body));
  }

  Future<Map> ChangeProfilePicture(File profilePicture) async {
    // Making multipart request
    var request = http.MultipartRequest(
        'PUT', Uri.parse(routeUrl + "user/changeProfilePicture"));

    // Adding headers
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    // Adding images
    MultipartFile profile = http.MultipartFile(
      'profile',
      profilePicture.readAsBytes().asStream(),
      profilePicture.lengthSync(),
      filename: profilePicture.path.split('/').last,
    );

    request.files.add(profile);

    final response = await request.send();
    var responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString) as Map;
    return {
      "statusCode": response.statusCode,
      "body": responseData,
    };
  }

  Future<Map> changeUserName(String username) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeUsername"),
      body: {"username": username},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }

  Future<Map> changeProfileName(String profilename) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeProfileName"),
      body: {"profile_name": profilename},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }

  Future<Map> changeEmail(String email) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeEmail"),
      body: {"email": email},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }

  Future<Map> changeBiography(String biography) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeBiography"),
      body: {"biography": biography},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }

  Future<Map> changeGender(String gender) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeGender"),
      body: {"gender": gender},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }

  Future<Map> changeBirthDate(String birthDate) async {
    final response = await put(
      Uri.parse(routeUrl + "user/changeBirthDate"),
      body: {"birth_date": birthDate},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData as Map,
    };
  }
}
