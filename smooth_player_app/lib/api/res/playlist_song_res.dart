import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

part 'playlist_song_res.g.dart';

@JsonSerializable()
class PlaylistSong {
  @JsonKey(name: "_id")
  String? id;

  Song? song;

  PlaylistSong({
    this.id,
    this.song,
  });

  factory PlaylistSong.fromJson(Map<String, dynamic> json) => _$PlaylistSongFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistSongToJson(this);
}
