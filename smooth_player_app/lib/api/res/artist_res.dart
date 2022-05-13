// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'artist_res.g.dart';

@JsonSerializable()
class Artist {
  @JsonKey(name: "_id")
  String? id;
  
  String? profile_name;

  Artist({this.profile_name});  
  
  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}