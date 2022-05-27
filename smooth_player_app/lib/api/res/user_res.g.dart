// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profile_name: json['profile_name'] as String?,
      profile_picture: json['profile_picture'] as String?,
      gender: json['gender'] as String?,
      birth_date: json['birth_date'] as String?,
      biography: json['biography'] as String?,
      follower: json['follower'] as int?,
      verified: json['verified'] as bool?,
      admin: json['admin'] as bool?,
      profile_publication: json['profile_publication'] as bool?,
      followed_artist_publication: json['followed_artist_publication'] as bool?,
      liked_album_publication: json['liked_album_publication'] as bool?,
      liked_song_publication: json['liked_song_publication'] as bool?,
      liked_featured_playlist_publication:
          json['liked_featured_playlist_publication'] as bool?,
      created_playlist_publication:
          json['created_playlist_publication'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'profile_name': instance.profile_name,
      'profile_picture': instance.profile_picture,
      'gender': instance.gender,
      'birth_date': instance.birth_date,
      'biography': instance.biography,
      'follower': instance.follower,
      'verified': instance.verified,
      'admin': instance.admin,
      'profile_publication': instance.profile_publication,
      'followed_artist_publication': instance.followed_artist_publication,
      'liked_song_publication': instance.liked_song_publication,
      'liked_album_publication': instance.liked_album_publication,
      'liked_featured_playlist_publication':
          instance.liked_featured_playlist_publication,
      'created_playlist_publication': instance.created_playlist_publication,
    };
