// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_song_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistSong _$PlaylistSongFromJson(Map<String, dynamic> json) => PlaylistSong(
      id: json['_id'] as String?,
      song: json['song'] == null
          ? null
          : Song.fromJson(json['song'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaylistSongToJson(PlaylistSong instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'song': instance.song,
    };
