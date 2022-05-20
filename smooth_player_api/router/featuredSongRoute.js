const express = require("express");
const mongoose = require("mongoose");
const router = new express.Router();
const auth = require("../authentication/auth");
const featuredSong = require("../model/featureSongModel");

router.delete("/delete/featuredPlaylistSong", auth.verifyAdmin, (req, res) => {
  featuredSong.findByIdAndDelete(req.body.featuredSongId).then(() => {
    res.send({ resM: "Song has been removed from featured playlist." });
  });
});

router.post("/upload/featuredSong", auth.verifyAdmin, (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  const songId = req.body.songId;

  for (i = 0; i < songId.length; i++) {
    new featuredSong({
      featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId),
      song: mongoose.Types.ObjectId(songId[i]),
    }).save();
  }

  res.status(201).send({ resM: "Songs added to featured playlist." });
});

router.post("/view/featuredSong", auth.verifyAdmin, async (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  const viewSongs = await featuredSong
    .find({ featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId) })
    .populate("song")
    .populate("featuredPlaylist")
    .sort({createdAt: -1});

  const viewSongs1 = await featuredSong.populate(viewSongs, {
    path: "song.album",
    select: "",
  });

  const viewSongs2 = await featuredSong.populate(viewSongs1, {
    path: "song.album.artist",
    select: "profile_name",
  });
  res.send(viewSongs2);
});

module.exports = router;
