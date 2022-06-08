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
    final response = await post(Uri.parse(routeUrl + "like/song"), body: {
      "songId": songId,
      "songTitle": songTitle,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkSongLike(String songId) async {
    final response = await post(
      Uri.parse(routeUrl + "like/checkSong"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }

  Future<List<Song>> viewLikedSongs() async {
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
  }

  Future<Map> likeAlbum(String albumId, String albumTitle) async {
    final response = await post(Uri.parse(routeUrl + "like/album"), body: {
      "albumId": albumId,
      "albumTitle": albumTitle,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkAlbumLike(String albumId) async {
    final response = await post(
      Uri.parse(routeUrl + "like/checkAlbum"),
      body: {"albumId": albumId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }

  Future<List<Album>> viewLikedAlbums() async {
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
  }

  Future<Map> likeFeaturedPlaylist(
      String featuredPlaylistId, String featuredPlaylistTitle) async {
    final response =
        await post(Uri.parse(routeUrl + "like/featuredPlaylist"), body: {
      "featuredPlaylistId": featuredPlaylistId,
      "featuredPlaylistTitle": featuredPlaylistTitle,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkFeaturedPlaylistLike(String featuredPlaylistId) async {
    final response = await post(
      Uri.parse(routeUrl + "like/checkFeaturedPlaylist"),
      body: {"featuredPlaylistId": featuredPlaylistId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    bool resData = jsonDecode(response.body);
    return resData;
  }

  Future<List<FeaturedPlaylist>> viewLikedFeaturedPlaylists() async {
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
  }
}
