// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/featured_playlist_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

part 'featured_song_res.g.dart';

@JsonSerializable(explicitToJson: true)
class FeaturedSong {
  @JsonKey(name: "_id")
  String? id;

  FeaturedPlaylist? featuredPlaylist;
  Song? song;

  FeaturedSong({
    this.id,
    this.featuredPlaylist,
    this.song,
  });

  factory FeaturedSong.fromJson(Map<String, dynamic> json) =>
      _$FeaturedSongFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedSongToJson(this);
}
