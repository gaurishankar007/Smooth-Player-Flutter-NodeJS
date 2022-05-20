// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      genre: json['genre'] as String?,
      album: json['album'] == null
          ? null
          : Album.fromJson(json['album'] as Map<String, dynamic>),
      music_file: json['music_file'] as String?,
      cover_image: json['cover_image'] as String?,
      like: json['like'] as int?,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'genre': instance.genre,
      'album': instance.album?.toJson(),
      'music_file': instance.music_file,
      'cover_image': instance.cover_image,
      'like': instance.like,
    };
