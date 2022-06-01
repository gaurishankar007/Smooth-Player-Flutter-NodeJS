// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      recentAlbums: (json['recentAlbums'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentFavoriteArtists: (json['recentFavoriteArtists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentFavoriteGenres: (json['recentFavoriteGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      jumpBackIn: (json['jumpBackIn'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      newReleases: (json['newReleases'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularFeaturedPlaylists:
          (json['popularFeaturedPlaylists'] as List<dynamic>?)
              ?.map((e) => FeaturedPlaylist.fromJson(e as Map<String, dynamic>))
              .toList(),
      popularAlbums: (json['popularAlbums'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularArtists: (json['popularArtists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'recentAlbums': instance.recentAlbums?.map((e) => e.toJson()).toList(),
      'recentFavoriteArtists':
          instance.recentFavoriteArtists?.map((e) => e.toJson()).toList(),
      'recentFavoriteGenres': instance.recentFavoriteGenres,
      'jumpBackIn': instance.jumpBackIn?.map((e) => e.toJson()).toList(),
      'newReleases': instance.newReleases?.map((e) => e.toJson()).toList(),
      'popularFeaturedPlaylists':
          instance.popularFeaturedPlaylists?.map((e) => e.toJson()).toList(),
      'popularAlbums': instance.popularAlbums?.map((e) => e.toJson()).toList(),
      'popularArtists':
          instance.popularArtists?.map((e) => e.toJson()).toList(),
    };
