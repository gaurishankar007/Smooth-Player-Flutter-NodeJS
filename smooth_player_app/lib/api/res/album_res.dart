// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

    part 'album_res.g.dart';

@JsonSerializable()
class Album {
  @JsonKey(name: "_id")
  String? id;

  String? title;
  String? artist;
  String? album_image;

  Album({
    this.id,
    this.title,
    this.artist,
    this.album_image
  });

  factory Album.fromJson(Map<String, dynamic> json) =>
      _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

}