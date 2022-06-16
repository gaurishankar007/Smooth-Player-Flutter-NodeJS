// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';

part 'song_res.g.dart';

@JsonSerializable(explicitToJson: true)
class Song {
  @JsonKey(name: "_id")
  String? id;

  String? title;
  String? genre;
  Album? album;
  String? music_file;
  String? cover_image;
  int? like;

  Song({
    this.id,
    this.title,
    this.genre,
    this.album,
    this.music_file,
    this.cover_image,
    this.like,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}
