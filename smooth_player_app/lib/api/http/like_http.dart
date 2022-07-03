import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import '../log_status.dart';
import '../res/featured_playlist_res.dart';
import '../res/song_res.dart';
import '../urls.dart';

class LikeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> likeSong(String songId, String songTitle) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "like/song"),
        body: {
          "songId": songId,
          "songTitle": songTitle,
        },
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

  Future<bool> checkSongLike(String songId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "like/checkSong"),
        body: {"songId": songId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      bool resData = jsonDecode(response.body);
      return resData;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Song>> viewLikedSongs() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/likedSongs"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resLikedSongs = jsonDecode(response.body);

      if (resLikedSongs.isEmpty) {
        return List.empty();
      }

      List<Song> likedSong = [];

      for (int i = 0; i < resLikedSongs.length; i++) {
        likedSong.add(Song.fromJson(resLikedSongs[i]["song"]));
      }

      return likedSong;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Map> likeAlbum(String albumId, String albumTitle) async {
    try {
      final response = await post(Uri.parse(routeUrl + "like/album"), body: {
        "albumId": albumId,
        "albumTitle": albumTitle,
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return jsonDecode(response.body) as Map;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<bool> checkAlbumLike(String albumId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "like/checkAlbum"),
        body: {"albumId": albumId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      bool resData = jsonDecode(response.body);
      return resData;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<int> getAlbumLike(String albumId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "check/albumLikeNum"),
        body: {"albumId": albumId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      int resData = jsonDecode(response.body);
      return resData;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Album>> viewLikedAlbums() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/likedAlbums"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resLikedAlbums = jsonDecode(response.body);

      if (resLikedAlbums.isEmpty) {
        return List.empty();
      }

      List<Album> likedAlbum = [];

      for (int i = 0; i < resLikedAlbums.length; i++) {
        likedAlbum.add(Album.fromJson(resLikedAlbums[i]["album"]));
      }

      return likedAlbum;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Map> likeFeaturedPlaylist(
      String featuredPlaylistId, String featuredPlaylistTitle) async {
    try {
      final response =
          await post(Uri.parse(routeUrl + "like/featuredPlaylist"), body: {
        "featuredPlaylistId": featuredPlaylistId,
        "featuredPlaylistTitle": featuredPlaylistTitle,
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      return jsonDecode(response.body) as Map;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<bool> checkFeaturedPlaylistLike(String featuredPlaylistId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "like/checkFeaturedPlaylist"),
        body: {"featuredPlaylistId": featuredPlaylistId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      bool resData = jsonDecode(response.body);
      return resData;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<int> getFeaturedPlaylistLike(String featuredPlaylistId) async {
    try {
      final response = await post(
        Uri.parse(routeUrl + "check/featuredPlaylistLikeNum"),
        body: {"featuredPlaylistId": featuredPlaylistId},
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      int resData = jsonDecode(response.body);
      return resData;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<FeaturedPlaylist>> viewLikedFeaturedPlaylists() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + "view/likedFeaturedPlaylists"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resLikedFeaturedPlaylists = jsonDecode(response.body);

      if (resLikedFeaturedPlaylists.isEmpty) {
        return List.empty();
      }

      List<FeaturedPlaylist> likedFeaturedPlaylist = [];

      for (int i = 0; i < resLikedFeaturedPlaylists.length; i++) {
        likedFeaturedPlaylist.add(FeaturedPlaylist.fromJson(
            resLikedFeaturedPlaylists[i]["featuredPlaylist"]));
      }

      return likedFeaturedPlaylist;
    } catch (error) {
      return Future.error(error);
    }
  }
}
