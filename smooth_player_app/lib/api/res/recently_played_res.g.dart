// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentlyPlayed _$RecentlyPlayedFromJson(Map<String, dynamic> json) =>
    RecentlyPlayed(
      id: json['_id'] as String?,
      user: json['user'] == null
          ? null
          : Artist.fromJson(json['user'] as Map<String, dynamic>),
      song: json['song'] == null
          ? null
          : Song.fromJson(json['song'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecentlyPlayedToJson(RecentlyPlayed instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user?.toJson(),
      'song': instance.song?.toJson(),
    };
