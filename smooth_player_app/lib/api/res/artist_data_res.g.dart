// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_data_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistData _$ArtistDataFromJson(Map<String, dynamic> json) => ArtistData(
      artist: json['artist'] == null
          ? null
          : Artist.fromJson(json['artist'] as Map<String, dynamic>),
      popularSong: (json['popularSong'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      newAlbum: (json['newAlbum'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      oldAlbum: (json['oldAlbum'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..id = json['_id'] as String?;

Map<String, dynamic> _$ArtistDataToJson(ArtistData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'artist': instance.artist?.toJson(),
      'popularSong': instance.popularSong?.map((e) => e.toJson()).toList(),
      'newAlbum': instance.newAlbum?.map((e) => e.toJson()).toList(),
      'oldAlbum': instance.oldAlbum?.map((e) => e.toJson()).toList(),
    };
