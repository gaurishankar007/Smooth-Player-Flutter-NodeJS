import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/api/res/playlist_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';
import 'package:smooth_player_app/api/res/user_res.dart';

part 'user_data_res.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  User? profile;
  List<Artist>? followedArtists;
  List<Song>? likedSongs;
  List<Album>? likedAlbums;
  List<FeaturedPlaylist>? likedFeaturedPlaylists;
  List<Playlist>? playlists;

  UserData({
    this.profile,
    this.followedArtists,
    this.likedSongs,
    this.likedAlbums,
    this.likedFeaturedPlaylists,
    this.playlists,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
