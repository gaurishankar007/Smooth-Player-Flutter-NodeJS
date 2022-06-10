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

router.post("/upload/featuredSong", auth.verifyAdmin, async (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  const songId = req.body.songId;
  var songExist = false;

  for (i = 0; i < songId.length; i++) {
    const featuredSongData = await featuredSong.findOne({
      featuredPlaylist: featuredPlaylistId,
      song: songId[i],
    });

    if (featuredSongData === null) {
      await featuredSong.create({
        featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId),
        song: mongoose.Types.ObjectId(songId[i]),
      });
    } else {
      songExist = true;
    }
  }

  if (songExist) {
    res
      .status(201)
      .send({
        resM: "Songs added to featured playlist except already existing ones.",
      });
  } else {
    res.status(201).send({ resM: "Songs added to featured playlist." });
  }
});

router.post("/view/featuredSong", auth.verifyAdmin, async (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  const viewSongs1 = await featuredSong
    .find({ featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId) })
    .populate("song")
    .populate("featuredPlaylist")
    .sort({ createdAt: -1 });

  const viewSongs2 = await featuredSong.populate(viewSongs1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const viewSongs = await featuredSong.populate(viewSongs2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(viewSongs);
});

router.post("/view/featuredSongs", auth.verifyUser, async (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  const viewSongs1 = await featuredSong
    .find({ featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId) })
    .populate("song")
    .populate("featuredPlaylist")
    .sort({ createdAt: -1 });

  const viewSongs2 = await featuredSong.populate(viewSongs1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const viewSongs = await featuredSong.populate(viewSongs2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(viewSongs);
});

module.exports = router;
