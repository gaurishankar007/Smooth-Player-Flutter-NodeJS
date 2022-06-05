const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const musicFile = require("../setting/songSetting");
const user = require("../model/userModel");
const album = require("../model/albumModel");
const song = require("../model/songModel");
const featuredPlaylist = require("../model/featurePlaylistModel");
const mongoose = require("mongoose");
const fs = require("fs");

router.post(
  "/upload/albumSong",
  auth.verifyUser,
  musicFile.array("song_file", 2),
  function (req, res) {
    if (req.files.length == 0) {
      res.status(400).send({ resM: "Unsupported file format." });
      return;
    } else if (req.body.title.trim() === "") {
      res.status(400).send({ resM: "Provide the song title." });
      return;
    }

    var music_file = "";
    var cover_image = "";

    for (i = 0; i < req.files.length; i++) {
      if (
        req.files[i].filename.split(".").pop() === "png" ||
        req.files[i].filename.split(".").pop() === "jpeg" ||
        req.files[i].filename.split(".").pop() === "jpg"
      ) {
        cover_image = req.files[i].filename;
      } else if (
        req.files[i].filename.split(".").pop() === "mp3" ||
        req.files[i].filename.split(".").pop() === "mp4"
      ) {
        music_file = req.files[i].filename;
      }
    }

    const newSong = new song({
      title: req.body.title,
      genre: req.body.genre,
      album: mongoose.Types.ObjectId(req.body.albumId),
      music_file: music_file,
      cover_image: cover_image,
    });

    newSong.save().then(() => {
      res
        .status(201)
        .send({ resM: "'" + req.body.title + "'" + " song uploaded." });
    });
  }
);

router.post(
  "/upload/singleSong",
  auth.verifyUser,
  musicFile.array("song_file", 2),
  async function (req, res) {
    if (req.files.length == 0) {
      res.status(400).send({ resM: "Unsupported file format." });
      return;
    } else if (req.body.title.trim() === "") {
      res.status(400).send({ resM: "Provide the song title." });
      return;
    }

    var music_file = "";
    var cover_image = "";

    for (i = 0; i < req.files.length; i++) {
      if (
        req.files[i].filename.split(".").pop() === "png" ||
        req.files[i].filename.split(".").pop() === "jpeg" ||
        req.files[i].filename.split(".").pop() === "jpg"
      ) {
        cover_image = req.files[i].filename;
      } else if (
        req.files[i].filename.split(".").pop() === "mp3" ||
        req.files[i].filename.split(".").pop() === "mp4"
      ) {
        music_file = req.files[i].filename;
      }
    }

    const newAlbum = await album.create({
      title: req.body.title,
      artist: req.userInfo._id,
      album_image: cover_image,
    });

    const newSong = new song({
      title: req.body.title,
      genre: req.body.genre,
      album: newAlbum._id,
      music_file: music_file,
      cover_image: cover_image,
    });

    newSong.save().then(() => {
      res
        .status(201)
        .send({ resM: "'" + req.body.title + "'" + " song uploaded." });
    });
  }
);

router.post("/view/song", auth.verifyUser, async (req, res) => {
  const songs1 = await song
    .find({ album: req.body.albumId })
    .populate("album", "title artist album_image like")
    .sort({ createdAt: -1 });

  const songs = await song.populate(songs1, {
    path: "album.artist",
    select: "profile_name profile_picture biography follower verified",
  });
  res.send(songs);
});

router.post("/adminView/song", auth.verifyAdmin, async (req, res) => {
  const songs1 = await song
    .find({ album: req.body.albumId })
    .populate("album", "title artist album_image like")
    .sort({ createdAt: -1 });

  const songs = await song.populate(songs1, {
    path: "album.artist",
    select: "profile_name profile_picture biography follower verified",
  });
  res.send(songs);
});

router.delete("/delete/song", auth.verifyUser, (req, res) => {
  song.findOne({ _id: req.body.songId }).then((songData) => {
    album.findOne({ _id: songData.album }).then((albumData) => {
      if (songData.cover_image !== albumData.album_image) {
        fs.unlinkSync(
          `../smooth_player_api/upload/image/album_song/${songData.cover_image}`
        );
      }
      fs.unlinkSync(`../smooth_player_api/upload/music/${songData.music_file}`);
      song.findByIdAndDelete(songData._id).then(() => {
        res.send({ resM: "song deleted." });
      });
    });
  });
});

router.put("/edit/song/title", auth.verifyUser, (req, res) => {
  if (req.body.title.trim() === "") {
    res.status(400).send({ resM: "Provide the song title." });
    return;
  }
  song
    .updateOne({ _id: req.body.songId }, { title: req.body.title })
    .then(() => {
      res.send({ resM: "Song Edited." });
    });
});

router.put(
  "/edit/song/image",
  auth.verifyUser,
  musicFile.single("song_file"),
  (req, res) => {
    if (req.file == undefined) {
      return res.status(400).send({
        resM: "Invalid image format, only supports png or jpeg image format.",
      });
    }
    song.findOne({ _id: req.body.songId }).then((songData) => {
      fs.unlinkSync(
        `../smooth_player_api/upload/image/album_song/${songData.cover_image}`
      );
      song
        .updateOne({ _id: songData._id }, { cover_image: req.file.filename })
        .then(() => {
          res.send({ resM: "Song Edited." });
        });
    });
  }
);

router.post("/search/songByTitle", auth.verifyAdmin, async (req, res) => {
  if (req.body.title.trim() === "") {
    return res.send([]);
  }
  const songTitle = { title: { $regex: req.body.title, $options: "i" } };

  const songs = await song.find(songTitle).populate("album").limit(20);
  const songs1 = await song.populate(songs, {
    path: "album.artist",
    select: "profile_name profile_picture biography verified",
  });
  res.send(songs1);
});

router.get("/search/genre", auth.verifyUser, async (req, res) => {
  const songGenres = [
    "Select song genre",
    "Adult contemporary music",
    "Alternative country",
    "Alternative hip hop",
    "Alternative rock",
    "Beach Music",
    "Blues",
    "Children's music",
    "Christian/Gospel",
    "Classic music",
    "Contemporary Christian music",
    "Country music",
    "Dance music",
    "Easy listening",
    "Electronic dance music",
    "Electronic music",
    "Experimental music",
    "Folk music",
    "Funk",
    "Hard rock",
    "Heavy Metal",
    "Hip hop music",
    "Indie rock",
    "Instrumental",
    "J-pop",
    "Japanese rock",
    "Jazz",
    "Jingle",
    "Latin alternative",
    "Latin music",
    "Metal, Musical theater",
    "New-age music",
    "Pop",
    "Popular music",
    "Post-disco",
    "Progressive rock",
    "Psychedelic rock",
    "Reggae",
    "Rhythm and blues",
    "Rock",
    "Singing",
    "Soul music",
    "Soundtrack",
    "Vocal music",
  ];

  const genres = [];

  for (let i = 0; i < songGenres.length; i++) {
    const singleSong = await song.findOne({ genre: songGenres[i] });
    if (singleSong !== null) {
      genres.push(songGenres[i]);
    }
  }

  res.send(genres);
});

router.post("/search/song", auth.verifyUser, async (req, res) => {
  if (req.body.title.trim() === "") {
    return res.send([]);
  }

  const songTitle = { title: { $regex: req.body.title, $options: "i" } };
  const albumTitle = { title: { $regex: req.body.title, $options: "i" } };
  const featuredPlaylistTitle = {
    title: { $regex: req.body.title, $options: "i" },
  };
  const artistName = {
    profile_name: { $regex: req.body.title, $options: "i" },
    verified: true,
    admin: false,
  };
  const userName = {
    profile_name: { $regex: req.body.title, $options: "i" },
    verified: false,
    admin: false,
  };

  const songs1 = await song.find(songTitle).populate("album").limit(10);
  const songs = await song.populate(songs1, {
    path: "album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  const albums = await album
    .find(albumTitle)
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    )
    .limit(10);

  const featuredPlaylists = await featuredPlaylist
    .find(featuredPlaylistTitle)
    .limit(10);

  const artists = await user.find(artistName).limit(10);

  const users = await user.find(userName).limit(10);

  res.send({
    songs: songs,
    albums: albums,
    featuredPlaylists: featuredPlaylists,
    artists: artists,
    users: users,
  });
});

router.post("/genre/songs", auth.verifyUser, async (req, res) => {
  const songNum = req.body.songNum;
  const songGenre = req.body.genre;

  const songs1 = await song
    .find({ genre: songGenre })
    .populate("album")
    .sort({ createdAt: -1 })
    .limit(songNum);

  const songs = await song.populate(songs1, {
    path: "album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(songs);
});

module.exports = router;
