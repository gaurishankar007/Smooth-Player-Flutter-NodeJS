// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_playlist_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedPlaylist _$FeaturedPlaylistFromJson(Map<String, dynamic> json) =>
    FeaturedPlaylist(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      featured_playlist_image: json['featured_playlist_image'] as String?,
      like: json['like'] as int?,
    );

Map<String, dynamic> _$FeaturedPlaylistToJson(FeaturedPlaylist instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'featured_playlist_image': instance.featured_playlist_image,
      'like': instance.like,
    };
