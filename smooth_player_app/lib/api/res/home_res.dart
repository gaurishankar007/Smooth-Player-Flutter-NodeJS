import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';

part 'home_res.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeData {
  List<Album>? recentAlbums;
  List<Artist>? recentFavoriteArtists;
  List<String>? recentFavoriteGenres;
  List<Album>? jumpBackIn;
  List<Album>? newReleases;
  List<FeaturedPlaylist>? popularFeaturedPlaylists;
  List<Album>? popularAlbums;
  List<Artist>? popularArtists;
  List<FeaturedPlaylist>? smoothPlayerFeaturedPlaylists;

  HomeData({
    this.recentAlbums,
    this.recentFavoriteArtists,
    this.recentFavoriteGenres,
    this.jumpBackIn,
    this.newReleases,
    this.popularFeaturedPlaylists,
    this.popularAlbums,
    this.popularArtists,
    this.smoothPlayerFeaturedPlaylists
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}
