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
  String? verified;
  String? admin;
  String? profile_publication;
  String? followed_artist_publication;
  String? liked_song_publication;
  String? liked_album_publication;
  String? liked_featured_playlist_publication;
  String? created_playlist_publication;

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
    this.verified,
    this.admin,
    this.profile_publication,
    this.followed_artist_publication,
    this.liked_album_publication,
    this.liked_song_publication,
    this.liked_featured_playlist_publication,
    this.created_playlist_publication,
  });
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
