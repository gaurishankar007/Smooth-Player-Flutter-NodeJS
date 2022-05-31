import 'dart:collection';
import "dart:math";
import 'package:audioplayers/audioplayers.dart';
import 'package:smooth_player_app/api/http/recently_played_http.dart';
import 'package:smooth_player_app/api/log_status.dart';

import '../api/res/song_res.dart';
import '../api/urls.dart';

class Player {
  final songUrl = ApiUrls.musicUrl;

  static final AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  static bool isPlaying = false;
  static bool isPaused = false;
  static bool isShuffle = false;
  static bool playingFromQueue = false;
  static bool autoNext = false;
  static int isLoop = 0;
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;
  static Song? playingSong;

  static List<Song> songsList = [];

  static Queue<Song> prevSongs = Queue();
  static Queue<Song> currentSong = Queue();
  static Queue<Song> nextSongs = Queue();

  static Queue<Song> songQueue = Queue();

  void playSong(Song song, List<Song> songs) {
    songsList = songs;
    bool songFound = false;

    if (playingSong == null) {
      for (int i = 0; i < songsList.length; i++) {
        if (songFound == false) {
          if (song.id != songsList[i].id) {
            prevSongs.addFirst(songsList[i]);
          } else {
            currentSong.add(songsList[i]);
            songFound = true;
          }
        } else {
          nextSongs.add(songsList[i]);
        }
      }
    } else {
      prevSongs.clear();
      currentSong.clear();
      nextSongs.clear();

      if (isShuffle) {
        currentSong.add(song);

        List<Song> tempSongsList = [];
        for (int i = 0; i < songsList.length; i++) {
          if (song.id != songsList[i].id) {
            tempSongsList.add(songsList[i]);
          }
        }
        int listLength = tempSongsList.length;

        for (int i = 0; i < listLength; i++) {
          int randomIndex = Random().nextInt(tempSongsList.length);
          nextSongs.add(tempSongsList[randomIndex]);
          tempSongsList.removeAt(randomIndex);
        }
      } else {
        for (int i = 0; i < songsList.length; i++) {
          if (songFound == false) {
            if (song.id != songsList[i].id) {
              prevSongs.addFirst(songsList[i]);
            } else {
              currentSong.add(songsList[i]);
              songFound = true;
            }
          } else {
            nextSongs.add(songsList[i]);
          }
        }
      }
    }

    startPlaying(song);
  }

  void startPlaying(Song song) async {
    if (!isPlaying) {
      isPlaying = true;
      playingSong = song;
      await player.play(songUrl + song.music_file!);
    } else {
      playingSong = song;
      await player.stop();
      await player.play(songUrl + song.music_file!);
    }

    if (!LogStatus.admin) {
      await RecentlyPlayedHttp().addRecentSong(song.id!);
    }
  }

  void pauseSong() async {
    if (playingSong == null) {
      return;
    }
    isPaused = true;
    await player.pause();
  }

  void resumeSong() async {
    if (playingSong == null) {
      return;
    }
    isPaused = false;
    await player.resume();
  }

  void autoNextSong() {
    if (autoNext) {
      return;
    }
    autoNext = true;
    if (songQueue.isEmpty) {
      if (nextSongs.isNotEmpty) {
        prevSongs.addFirst(currentSong.removeFirst());
        currentSong.add(nextSongs.removeFirst());
        startPlaying(currentSong.first);
      } else {
        if (isShuffle) {
          shuffleSongMore();
        } else {
          if (isLoop == 2) {
            prevSongs.clear();
            currentSong.clear();

            for (int i = 0; i < songsList.length; i++) {
              if (i == 0) {
                currentSong.add(songsList[i]);
              } else {
                nextSongs.add(songsList[i]);
              }
            }

            startPlaying(currentSong.first);
          } else {
            Player.isPaused = true;
            return;
          }
        }
      }

      playingFromQueue = false;
    } else {
      playingFromQueue = true;
      startPlaying(songQueue.removeFirst());
    }
  }

  void nextSong() {
    if (songQueue.isEmpty) {
      if (nextSongs.isNotEmpty) {
        prevSongs.addFirst(currentSong.removeFirst());
        currentSong.add(nextSongs.removeFirst());
        startPlaying(currentSong.first);
      } else {
        if (isShuffle) {
          shuffleSongMore();
        } else {
          prevSongs.clear();
          currentSong.clear();

          for (int i = 0; i < songsList.length; i++) {
            if (i == 0) {
              currentSong.add(songsList[i]);
            } else {
              nextSongs.add(songsList[i]);
            }
          }

          startPlaying(currentSong.first);
        }
      }

      playingFromQueue = false;
    } else {
      playingFromQueue = true;
      startPlaying(songQueue.removeFirst());
    }
  }

  void previousSong() {
    if (playingFromQueue) {
      startPlaying(currentSong.first);
      return;
    }
    if (prevSongs.isNotEmpty) {
      nextSongs.addFirst(currentSong.removeFirst());
      currentSong.add(prevSongs.removeFirst());
      startPlaying(currentSong.first);
    } else {
      currentSong.clear();
      nextSongs.clear();

      for (int i = 0; i < songsList.length; i++) {
        if (i != songsList.length - 1) {
          prevSongs.addFirst(songsList[i]);
        } else {
          currentSong.add(songsList[i]);
        }
      }

      startPlaying(currentSong.first);
    }
  }

  void shuffleSong() {
    isShuffle = true;

    prevSongs.clear();
    nextSongs.clear();

    List<Song> tempSongsList = [];
    for (int i = 0; i < songsList.length; i++) {
      if (playingSong!.id != songsList[i].id) {
        tempSongsList.add(songsList[i]);
      }
    }
    int listLength = tempSongsList.length;

    for (int i = 0; i < listLength; i++) {
      int randomIndex = Random().nextInt(tempSongsList.length);
      nextSongs.add(tempSongsList[randomIndex]);
      tempSongsList.removeAt(randomIndex);
    }
  }

  void shuffleSongMore() {
    prevSongs.clear();

    List<Song> tempSongsList = [];
    for (int i = 0; i < songsList.length; i++) {
      if (playingSong!.id != songsList[i].id) {
        tempSongsList.add(songsList[i]);
      }
    }
    int listLength = tempSongsList.length;

    for (int i = 0; i < listLength; i++) {
      int randomIndex = Random().nextInt(tempSongsList.length);
      nextSongs.add(tempSongsList[randomIndex]);
      tempSongsList.removeAt(randomIndex);
    }

    nextSongs.add(currentSong.removeFirst());
    currentSong.add(nextSongs.removeFirst());
    startPlaying(currentSong.first);
  }

  void stopShuffle() {
    isShuffle = false;

    prevSongs.clear();
    currentSong.clear();
    nextSongs.clear();

    bool songFound = false;

    for (int i = 0; i < songsList.length; i++) {
      if (songFound == false) {
        if (playingSong!.id != songsList[i].id) {
          prevSongs.addFirst(songsList[i]);
        } else {
          currentSong.add(songsList[i]);
          songFound = true;
        }
      } else {
        nextSongs.add(songsList[i]);
      }
    }
  }

  void singleLoop() async {
    isLoop = 1;
    await player.setReleaseMode(ReleaseMode.LOOP);
  }

  void multiLoop() async {
    isLoop = 2;
    await player.setReleaseMode(ReleaseMode.RELEASE);
  }

  void stopLoop() async {
    isLoop = 0;
  }

  void stopSong() async {
    int result = await player.stop();
    if (result == 1) {
      Player.playingSong = null;
      isPlaying = false;
      isPaused = false;
      isShuffle = false;
      playingFromQueue = false;
      isLoop = 0;
      duration = Duration.zero;
      position = Duration.zero;

      songsList = [];
      prevSongs.clear();
      currentSong.clear();
      nextSongs.clear();
      songQueue.clear();
    }
  }
}
