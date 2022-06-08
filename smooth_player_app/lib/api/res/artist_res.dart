// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'artist_res.g.dart';

@JsonSerializable()
class Artist {
  @JsonKey(name: "_id")
  String? id;

  String? profile_name;
  String? profile_picture;
  String? biography;
  int? follower;
  bool? verified;

  Artist({
    this.id,
    this.profile_name,
    this.profile_picture,
    this.biography,
    this.verified,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
