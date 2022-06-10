const express = require("express");
const mongoose = require("mongoose");
const router = new express.Router();
const auth = require("../authentication/auth");
const playlistSong = require("../model/playlistSongModel");

router.post("/add/playlistSong", auth.verifyUser, async (req, res) => {
  const playlistId = req.body.playlistId;
  const songId = req.body.songId;

  playlistSongData = await playlistSong.findOne({
    playlist: playlistId,
    song: songId,
  });

  if (playlistSongData === null) {
    await playlistSong.create({
      playlist: mongoose.Types.ObjectId(playlistId),
      song: mongoose.Types.ObjectId(songId),
    });

    res.status(201).send({ resM: "Song added to the playlist." });
  } else {
    res.status(400).send({ resM: "Song already exists in the playlist." });
  }
});

router.delete("/delete/playlistSong", auth.verifyUser, (req, res) => {
  playlistSong.findByIdAndDelete(req.body.playlistSongId).then(() => {
    res.send({ resM: "Song has been removed from the playlist." });
  });
});

router.post("/playlist/songs", auth.verifyUser, async (req, res) => {
  const playlistId = req.body.playlistId;

  const songs1 = await playlistSong
    .find({ playlist: playlistId })
    .populate("song")
    .sort({ createdAt: -1 });

  const songs2 = await playlistSong.populate(songs1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const songs = await playlistSong.populate(songs2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(songs);
});

module.exports = router;
