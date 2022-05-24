// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      profile_name: json['profile_name'] as String?,
      profile_picture: json['profile_picture'] as String?,
      biography: json['biography'] as String?,
      verified: json['verified'] as bool?,
    )
      ..id = json['_id'] as String?
      ..follower = json['follower'] as int?;

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      '_id': instance.id,
      'profile_name': instance.profile_name,
      'profile_picture': instance.profile_picture,
      'biography': instance.biography,
      'follower': instance.follower,
      'verified': instance.verified,
    };
