// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'featured_playlist_res.g.dart';

@JsonSerializable(explicitToJson: true)
class FeaturedPlaylist {
  @JsonKey(name: "_id")
  String? id;

  String? title;
  String? featured_playlist_image;
  int? like;

  FeaturedPlaylist({
    this.id,
    this.title,
    this.featured_playlist_image,
    this.like,
  });

  factory FeaturedPlaylist.fromJson(Map<String, dynamic> json) =>
      _$FeaturedPlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedPlaylistToJson(this);
}
