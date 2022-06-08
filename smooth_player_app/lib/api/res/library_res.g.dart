// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryData _$LibraryDataFromJson(Map<String, dynamic> json) => LibraryData(
      profilePicture: json['profilePicture'] as String?,
      checkPlaylists: json['checkPlaylists'] as bool?,
      checkFollows: json['checkFollows'] as bool?,
      checkLikedSongs: json['checkLikedSongs'] as bool?,
      checkLikedAlbums: json['checkLikedAlbums'] as bool?,
      checkLikedFeaturedPlaylists: json['checkLikedFeaturedPlaylists'] as bool?,
      albums: (json['albums'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userPlaylists: (json['userPlaylists'] as List<dynamic>?)
          ?.map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LibraryDataToJson(LibraryData instance) =>
    <String, dynamic>{
      'profilePicture': instance.profilePicture,
      'checkPlaylists': instance.checkPlaylists,
      'checkFollows': instance.checkFollows,
      'checkLikedSongs': instance.checkLikedSongs,
      'checkLikedAlbums': instance.checkLikedAlbums,
      'checkLikedFeaturedPlaylists': instance.checkLikedFeaturedPlaylists,
      'albums': instance.albums?.map((e) => e.toJson()).toList(),
      'artists': instance.artists?.map((e) => e.toJson()).toList(),
      'genres': instance.genres,
      'userPlaylists': instance.userPlaylists?.map((e) => e.toJson()).toList(),
    };
