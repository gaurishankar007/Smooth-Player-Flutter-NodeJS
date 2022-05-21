// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

part 'recently_played_res.g.dart';

@JsonSerializable(explicitToJson: true)
class RecentlyPlayed {
  @JsonKey(name: "_id")
  String? id;

  Artist? user;
  Song? song;

  RecentlyPlayed({this.id, this.user, this.song});

  factory RecentlyPlayed.fromJson(Map<String, dynamic> json) =>
      _$RecentlyPlayedFromJson(json);

  Map<String, dynamic> toJson() => _$RecentlyPlayedToJson(this);
}
