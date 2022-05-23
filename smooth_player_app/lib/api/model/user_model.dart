// ignore_for_file: non_constant_identifier_names

import 'dart:io';

class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? profile_name;
  String? profile_picture;
  String? gender;
  String? birth_date;
  String? biography;
  int? follower;
  String? verified;
  String? admin;
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
    this.password,
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'] as String?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        profile_name: json['profile_name'] as String?,
        profile_picture: json['profile_picture'] as String?,
        gender: json['gender'] as String?,
        birth_date: json['birth_date'] as String?,
        biography: json['biography'] as String?,
        follower: json['follower'] as int?,
        profile_publication: json['profile_publication'] as bool?,
        followed_artist_publication:
            json['followed_artist_publication'] as bool?,
        liked_album_publication: json['liked_album_publication'] as bool?,
        liked_song_publication: json['liked_song_publication'] as bool?,
        liked_featured_playlist_publication:
            json['liked_featured_playlist_publication'] as bool?,
        created_playlist_publication:
            json['created_playlist_publication'] as bool?,
      );
}

class UploadUser {
  String? username;
  String? email;
  String? password;
  String? confirm_password;

  String? profile_name;
  File? profile_picture;
  String? gender;
  String? birth_date;
  String? biography;

  UploadUser({
    this.username,
    this.email,
    this.password,
    this.confirm_password,
    this.profile_name,
    this.profile_picture,
    this.gender,
    this.birth_date,
    this.biography,
  });
}
