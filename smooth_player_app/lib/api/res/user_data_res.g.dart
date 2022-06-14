// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      profile: json['profile'] == null
          ? null
          : User.fromJson(json['profile'] as Map<String, dynamic>),
      followedArtists: (json['followedArtists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedSongs: (json['likedSongs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedAlbums: (json['likedAlbums'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedFeaturedPlaylists: (json['likedFeaturedPlaylists'] as List<dynamic>?)
          ?.map((e) => FeaturedPlaylist.fromJson(e as Map<String, dynamic>))
          .toList(),
      playlists: (json['playlists'] as List<dynamic>?)
          ?.map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'profile': instance.profile?.toJson(),
      'followedArtists':
          instance.followedArtists?.map((e) => e.toJson()).toList(),
      'likedSongs': instance.likedSongs?.map((e) => e.toJson()).toList(),
      'likedAlbums': instance.likedAlbums?.map((e) => e.toJson()).toList(),
      'likedFeaturedPlaylists':
          instance.likedFeaturedPlaylists?.map((e) => e.toJson()).toList(),
      'playlists': instance.playlists?.map((e) => e.toJson()).toList(),
    };
