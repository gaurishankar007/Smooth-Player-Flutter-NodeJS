// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      artist: json['artist'] == null
          ? null
          : Artist.fromJson(json['artist'] as Map<String, dynamic>),
      album_image: json['album_image'] as String?,
      like: json['like'] as int?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'artist': instance.artist?.toJson(),
      'album_image': instance.album_image,
      'like': instance.like,
    };
