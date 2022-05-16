// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_song_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedSong _$FeaturedSongFromJson(Map<String, dynamic> json) => FeaturedSong(
      id: json['_id'] as String?,
      featuredPlaylist: json['featuredPlaylist'] == null
          ? null
          : FeaturedPlaylist.fromJson(
              json['featuredPlaylist'] as Map<String, dynamic>),
      song: json['song'] == null
          ? null
          : Song.fromJson(json['song'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeaturedSongToJson(FeaturedSong instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'featuredPlaylist': instance.featuredPlaylist?.toJson(),
      'song': instance.song?.toJson(),
    };
