// ignore_for_file: non_constant_identifier_names

import 'dart:io';

class SongUploadModal {
  String? id;
  String? title;
  String? genre;
  File? music_file;
  File? cover_image;
  SongUploadModal({
    this.id,
    this.title,
    this.genre,
    this.music_file,
    this.cover_image,
  });
}
