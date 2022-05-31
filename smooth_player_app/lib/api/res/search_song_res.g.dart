// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_song_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      albums: (json['albums'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredPlaylists: (json['featuredPlaylists'] as List<dynamic>?)
          ?.map((e) => FeaturedPlaylist.fromJson(e as Map<String, dynamic>))
          .toList(),
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'songs': instance.songs?.map((e) => e.toJson()).toList(),
      'albums': instance.albums?.map((e) => e.toJson()).toList(),
      'featuredPlaylists':
          instance.featuredPlaylists?.map((e) => e.toJson()).toList(),
      'artists': instance.artists?.map((e) => e.toJson()).toList(),
      'users': instance.users?.map((e) => e.toJson()).toList(),
    };
