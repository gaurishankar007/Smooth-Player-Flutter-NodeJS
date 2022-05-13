// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      profile_name: json['profile_name'] as String?,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      '_id': instance.id,
      'profile_name': instance.profile_name,
    };
