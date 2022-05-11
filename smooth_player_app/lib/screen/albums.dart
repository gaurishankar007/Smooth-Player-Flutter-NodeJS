import 'package:flutter/material.dart';
// import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/api/res/song_res.dart';

import '../api/http/song_http.dart';
import '../widget/navigator.dart';
// import 'package:smooth_player_app/widgets/song_bar.dart';

// import '../player.dart';

class AlbumView extends StatefulWidget {
  final String? albumId;
  final int? pageIndex;
  const AlbumView({Key? key, @required this.albumId, @required this.pageIndex})
      : super(key: key);

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  // Song? song = Player.playingSong;

  late List<Song> songs;

  Future<List<Song>> viewSongs() async {
    List<Song> resData = await SongHttp().getSongs(widget.albumId!);
    return resData;
  }

  @override
  void initState() {
    super.initState();

    viewSongs().then((value) {
      setState(() {
        songs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Song>>(
        future: viewSongs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    Song newSong = Song(
                      id: snapshot.data![index].id!,
                      title: snapshot.data![index].title!,
                      album: snapshot.data![index].album!,
                      music_file: snapshot.data![index].music_file!,
                      cover_image: snapshot.data![index].cover_image!,
                      // players: snapshot.data![index].players!,
                      like: snapshot.data![index].like!,
                    );

                    // Player().playSong(newSong, songs);

                    // setState(() {
                    //   song = newSong;
                    // });
                  },
                  leading: Text("${index + 1}"),
                  title: Text(
                    snapshot.data![index].title!,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    snapshot.data![index].album!.title!,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // Player.songQueue.add(Song(
                      //   id: snapshot.data![index].id!,
                      //   title: snapshot.data![index].title!,
                      //   album: snapshot.data![index].album!,
                      //   music_file: snapshot.data![index].music_file!,
                      //   cover_image: snapshot.data![index].cover_image!,
                      //   players: snapshot.data![index].players!,
                      //   like: snapshot.data![index].like!,
                      // ));
                    },
                    icon: Icon(
                      Icons.queue_play_next_rounded,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Colors.greenAccent,
            ),
          );
        },
      ),
      // floatingActionButton: song != null
      //     ? SongBar(
      //         songData: song,
      //       )
      //     : null,
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: PageNavigator(pageIndex: widget.pageIndex),
    );
  }
}
