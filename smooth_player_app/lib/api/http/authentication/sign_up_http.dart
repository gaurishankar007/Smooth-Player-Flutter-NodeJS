import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../log_status.dart';
import '../../model/user_model.dart';
import '../../urls.dart';

class SignUpHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> signUp(UploadUser userDetails) async {
    try {
      // Making multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse(routeUrl + "user/register"));

      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Adding forms data
      Map<String, String> userData = {
        "username": userDetails.username!,
        "email": userDetails.email!,
        "password": userDetails.password!,
        "confirm_password": userDetails.confirm_password!,
        "profile_name": userDetails.profile_name!,
        "gender": userDetails.gender!,
        "birth_date": userDetails.birth_date!,
        "biography": userDetails.biography!
      };
      request.fields.addAll(userData);

      // Adding images
      List<MultipartFile> multipartList = [];
      multipartList.add(http.MultipartFile(
        'profile',
        userDetails.profile_picture!.readAsBytes().asStream(),
        userDetails.profile_picture!.lengthSync(),
        filename: userDetails.profile_picture!.path.split('/').last,
      ));
      request.files.addAll(multipartList);

      final response = await request.send();
      var responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString) as Map;
      return {
        "statusCode": response.statusCode,
        "body": responseData,
      };
    } catch (error) {
      return {
        "body": {"resM": "error occurred"},
        "statusCode": 400,
      };
    }
  }
}
