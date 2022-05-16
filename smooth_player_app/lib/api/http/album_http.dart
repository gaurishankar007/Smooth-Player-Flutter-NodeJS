import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../log_status.dart';
import '../model/album_model.dart';
import '../res/album_res.dart';
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
      "body": {"resM": "error occurred"},
      "statusCode": 400,
    };
  }

  Future<List<Album>> getAlbums() async {
    final response = await get(
      Uri.parse(routeUrl + "view/album"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resAlbum = jsonDecode(response.body);

    if (resAlbum.isEmpty) {
      return List.empty();
    }

    return resAlbum.map((e) => Album.fromJson(e)).toList();
  }

  Future<Map> deleteAlbum(String albumId) async {
    final bearerToken = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    final response = await delete(Uri.parse(routeUrl + "delete/album"),
        body: {"albumId": albumId}, headers: bearerToken);

    final responseData = jsonDecode(response.body);

    return responseData;
  }

  Future<Map> editAlbumTitle(AlbumUploadModal albumData) async {
    final response = await put(
      Uri.parse(routeUrl + "edit/album/title"),
      body: {"title": albumData.title},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "body": responseData,
    };
  }
  Future<Map> editAlbumImage(AlbumUploadModal albumData) async {
   try {
      // Making multipart request
      var request =
          http.MultipartRequest('PUT', Uri.parse(routeUrl + "edit/album/image"));
      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
     
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
      "body": {"resM": "error occurred"},
      "statusCode": 400,
    };
  }
}
