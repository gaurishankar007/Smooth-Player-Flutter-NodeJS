import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_player_app/api/res/album_res.dart';
import 'package:smooth_player_app/api/res/artist_res.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

part 'artist_data_res.g.dart';

@JsonSerializable(explicitToJson: true)
class ArtistData {
  Artist? artist;
  List<Song>? popularSong;
  List<Album>? newAlbum;
  List<Album>? oldAlbum;

  ArtistData({
    this.artist,
    this.popularSong,
    this.newAlbum,
    this.oldAlbum,
  });

  factory ArtistData.fromJson(Map<String, dynamic> json) =>
      _$ArtistDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistDataToJson(this);
}
