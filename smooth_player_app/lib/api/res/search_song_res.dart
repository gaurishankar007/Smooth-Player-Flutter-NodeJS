import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

part 'search_song_res.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchData {
  List<Song>? songs;
  List<Album>? albums;
  List<FeaturedPlaylist>? featuredPlaylists;
  List<Artist>? artists;
  List<Artist>? users;

  SearchData({
    this.songs,
    this.albums,
    this.featuredPlaylists,
    this.artists,
    this.users,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}
