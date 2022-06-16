import 'package:json_annotation/json_annotation.dart';

import 'artist_res.dart';
import 'song_res.dart';

part 'report_res.g.dart';

@JsonSerializable()
class Report {
  @JsonKey(name: "_id")
  String? id;

  Artist? user;
  Song? song;
  String? message;
  List<String>? reportFor;
  bool? solved;

  Report({
    this.id,
    this.user,
    this.song,
    this.message,
    this.reportFor,
    this.solved,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
