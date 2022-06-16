// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['_id'] as String?,
      user: json['user'] == null
          ? null
          : Artist.fromJson(json['user'] as Map<String, dynamic>),
      song: json['song'] == null
          ? null
          : Song.fromJson(json['song'] as Map<String, dynamic>),
      message: json['message'] as String?,
      reportFor: (json['reportFor'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      solved: json['solved'] as bool?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'song': instance.song,
      'message': instance.message,
      'reportFor': instance.reportFor,
      'solved': instance.solved,
    };
