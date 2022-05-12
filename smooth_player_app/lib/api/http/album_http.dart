import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/model/upload_modal.dart';
import 'package:http/http.dart' as http;

import '../log_status.dart';
import '../urls.dart';

class AlbumHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> createAlbum(AlbumUploadModal albumData) async {
    try {
      // Making multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse(routeUrl + "upload/album"));
      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      // Adding forms data
      Map<String, String> albumDetail = {
        "title": "${albumData.title}",
      };
      request.fields.addAll(albumDetail);
      // Adding images
      List<MultipartFile> multipartList = [];
      multipartList.add(http.MultipartFile(
        'album_image',
        albumData.cover_image!.readAsBytes().asStream(),
        albumData.cover_image!.lengthSync(),
        filename: albumData.cover_image!.path.split('/').last,
      ));
      request.files.addAll(multipartList);
      final response = await request.send();
      var responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString) as Map;
      return {
        "statusCode": response.statusCode,
        "body": responseData,
      };
    } catch (err) {
      log('$err');
    }
    return {
      "body": {"resM": "error occured"},
      "statusCode": 400,
    };
  }
}
