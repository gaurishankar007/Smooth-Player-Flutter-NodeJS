import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:smooth_player_app/api/model/album_model.dart';
import 'package:http/http.dart' as http;
import '../res/song_res.dart';
import '../urls.dart';

class SongHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;
  
  Future<Map> uploadSingleSong(SongUploadModal songData) async {
    try {
      // Making multipart request
      var request = http.MultipartRequest(
          'POST', Uri.parse(routeUrl + "upload/singleSong"));
      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      // Adding forms data
      Map<String, String> songDetail = {
        "title": "${songData.title}",
      };
      request.fields.addAll(songDetail);
      // Adding song
      List<MultipartFile> multipartList = [];
      multipartList.add(http.MultipartFile(
        'song_file',
        songData.music_file!.readAsBytes().asStream(),
        songData.music_file!.lengthSync(),
        filename: songData.music_file!.path.split('/').last,
      ));
      // Adding images
      multipartList.add(http.MultipartFile(
        'song_file',
        songData.cover_image!.readAsBytes().asStream(),
        songData.cover_image!.lengthSync(),
        filename: songData.cover_image!.path.split('/').last,
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


  Future<Map> uploadAlbumSong(SongUploadModal songData, String albumId) async {
    try {
      // Making multipart request
      var request = http.MultipartRequest(
          'POST', Uri.parse(routeUrl + "upload/albumSong"));
      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      // Adding forms data
      Map<String, String> songDetail = {
        "title": "${songData.title}",
        "albumId": albumId,
      };
      request.fields.addAll(songDetail);
      // Adding song
      List<MultipartFile> multipartList = [];
      multipartList.add(http.MultipartFile(
        'song_file',
        songData.music_file!.readAsBytes().asStream(),
        songData.music_file!.lengthSync(),
        filename: songData.music_file!.path.split('/').last,
      ));
      // Adding images
      multipartList.add(http.MultipartFile(
        'song_file',
        songData.cover_image!.readAsBytes().asStream(),
        songData.cover_image!.lengthSync(),
        filename: songData.cover_image!.path.split('/').last,
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

  Future<List<Song>> getSongs(String albumId) async {
    final response = await post(
      Uri.parse(routeUrl + "view/song"),
      body: {"albumId": albumId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resSongs = jsonDecode(response.body);

    if (resSongs.isEmpty) {
      return List.empty();
    }

    return resSongs.map((e) => Song.fromJson(e)).toList();
  }
}
