// ignore_for_file: non_constant_identifier_names

import 'dart:io';

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
