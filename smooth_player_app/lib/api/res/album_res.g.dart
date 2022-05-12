// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      artist: json['artist'] as String?,
      album_image: json['album_image'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'album_image': instance.album_image,
    };
