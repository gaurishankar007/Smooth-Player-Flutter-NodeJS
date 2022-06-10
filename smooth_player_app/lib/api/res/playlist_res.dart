import 'package:json_annotation/json_annotation.dart';

part 'playlist_res.g.dart';

@JsonSerializable()
class Playlist {
  @JsonKey(name: "_id")
  String? id;

  String? title;

  Playlist({
    this.id,
    this.title,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
