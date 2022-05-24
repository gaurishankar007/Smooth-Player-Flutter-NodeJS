// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'artist_res.dart';

part 'album_res.g.dart';

@JsonSerializable(explicitToJson: true)
class Album {
  @JsonKey(name: "_id")
  String? id;

  String? title;
  Artist? artist;
  String? album_image;
  int? like;

  Album({
    this.id,
    this.title,
    this.artist,
    this.album_image,
    this.like,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
