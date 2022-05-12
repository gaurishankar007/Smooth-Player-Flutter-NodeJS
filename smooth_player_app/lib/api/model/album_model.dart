// ignore_for_file: non_constant_identifier_names
import 'dart:io';
class AlbumUploadModal {
   String? id;
  String? title;
  File? cover_image;
  AlbumUploadModal({
    this.id,
    this.title,
    this.cover_image,
  });
}

class SongUploadModal {
   String? id;
  String? title;
  File? music_file;
  File? cover_image;
  SongUploadModal({
    this.id,
    this.title,
    this.music_file,
    this.cover_image,
  });
}