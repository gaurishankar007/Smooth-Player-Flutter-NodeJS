import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/playlist_res.dart';

part 'library_res.g.dart';

@JsonSerializable(explicitToJson: true)
class LibraryData {
  String? profilePicture;
  bool? checkPlaylists;
  bool? checkFollows;
  bool? checkLikedSongs;
  bool? checkLikedAlbums;
  bool? checkLikedFeaturedPlaylists;
  List<Album>? albums;
  List<Artist>? artists;
  List<String>? genres;
  List<Playlist>? userPlaylists;

  LibraryData({
    this.profilePicture,
    this.checkPlaylists,
    this.checkFollows,
    this.checkLikedSongs,
    this.checkLikedAlbums,
    this.checkLikedFeaturedPlaylists,
    this.albums,
    this.artists,
    this.genres,
    this.userPlaylists,
  });

  factory LibraryData.fromJson(Map<String, dynamic> json) =>
      _$LibraryDataFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryDataToJson(this);
}
