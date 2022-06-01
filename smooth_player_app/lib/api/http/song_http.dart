import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:smooth_player_app/api/log_status.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_player_app/api/res/search_song_res.dart';
import '../model/song_model.dart';
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
        "genre": "${songData.genre}",
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
        "genre": "${songData.genre}",
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

  Future<List<Song>> getSongsAdmin(String albumId) async {
    final response = await post(
      Uri.parse(routeUrl + "adminView/song"),
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

  Future<Map> deleteSong(String songId) async {
    final bearerToken = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    final response = await delete(Uri.parse(routeUrl + "delete/song"),
        body: {"songId": songId}, headers: bearerToken);

    final responseData = jsonDecode(response.body);

    return responseData;
  }

  Future<Map> editSongTitle(String title, String songId) async {
    final response = await put(
      Uri.parse(routeUrl + "edit/song/title"),
      body: {"title": title, "songId": songId},
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

  Future<Map> editSongImage(File image, String songId) async {
    try {
      // Making multipart request
      var request =
          http.MultipartRequest('PUT', Uri.parse(routeUrl + "edit/song/image"));
      // Adding headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Adding song
      List<MultipartFile> multipartList = [];
      // Adding forms data
      Map<String, String> songDetail = {
        "songId": songId,
      };
      request.fields.addAll(songDetail);
      // Adding images
      multipartList.add(http.MultipartFile(
        'song_file',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
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

  Future<List<Song>> searchSongByTitle(String title) async {
    final response = await post(
      Uri.parse(routeUrl + "search/songByTitle"),
      body: {"title": title},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    List resSearch = jsonDecode(response.body);
    return resSearch.map((e) => Song.fromJson(e)).toList();
  }

  Future<List> searchGenre() async {
    final response = await get(
      Uri.parse(routeUrl + "search/genre"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    
    List songGenres = jsonDecode(response.body);
    return songGenres;
  }

  Future<SearchData> searchSong(String title) async {
    final response = await post(
      Uri.parse(routeUrl + "search/song"),
      body: {"title": title},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return SearchData.fromJson(jsonDecode(response.body));
  }
}
