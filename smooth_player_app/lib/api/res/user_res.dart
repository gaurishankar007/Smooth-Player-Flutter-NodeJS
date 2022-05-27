// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'user_res.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "_id")
  String? id;

  String? username;
  String? email;
  String? profile_name;
  String? profile_picture;
  String? gender;
  String? birth_date;
  String? biography;
  int? follower;
  bool? verified;
  bool? admin;
  bool? profile_publication;
  bool? followed_artist_publication;
  bool? liked_song_publication;
  bool? liked_album_publication;
  bool? liked_featured_playlist_publication;
  bool? created_playlist_publication;

  User({
    this.id,
    this.username,
    this.email,
    this.profile_name,
    this.profile_picture,
    this.gender,
    this.birth_date,
    this.biography,
    this.follower,
    this.verified,
    this.admin,
    this.profile_publication,
    this.followed_artist_publication,
    this.liked_album_publication,
    this.liked_song_publication,
    this.liked_featured_playlist_publication,
    this.created_playlist_publication,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
