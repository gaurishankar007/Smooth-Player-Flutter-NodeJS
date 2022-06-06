const express = require("express");
const mongoose = require("mongoose");
const router = new express.Router();
const auth = require("../authentication/auth");
const playlistSong = require("../model/playlistSongModel");

router.post("/add/playlistSong", auth.verifyUser, (req, res) => {
  const playlistId = req.body.playlistId;
  const songId = req.body.songId;

  const newPlaylist = new playlistSong({
    playlist: mongoose.Types.ObjectId(playlistId),
    song: mongoose.Types.ObjectId(songId),
  });

  newPlaylist.save().then(() => {
    res.status(201).send({ resM: "Song added to the playlist." });
  });
});

router.delete("/delete/playlistSong", auth.verifyUser, (req, res) => {
  playlistSong.findByIdAndDelete(req.body.playlistSongId).then(() => {
    res.send({ resM: "Song has been removed from the playlist." });
  });
});

module.exports = router;
