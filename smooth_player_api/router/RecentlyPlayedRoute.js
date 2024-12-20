const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const recentlyPlayed = require("../model/RecentlyPlayedModel");

router.post("/add/recentSong", auth.verifyUser, async (req, res) => {
  const recentCount = await recentlyPlayed.count({ user: req.userInfo._id });
  if (recentCount >= 200) {
    recentlyPlayed
      .findOneAndDelete({ user: req.userInfo._id }, { sort: { _id: 1 } })
      .then();
  }

  new recentlyPlayed({
    user: req.userInfo._id,
    song: mongoose.Types.ObjectId(req.body.songId),
  })
    .save()
    .then(() => {
      res.status(201).send({ resM: "Song added to recently played list." });
    });
});

router.get("/view/recentSong", auth.verifyUser, async (req, res) => {
  const recentSongs1 = await recentlyPlayed
    .find({ user: req.userInfo._id })
    .populate(
      "user",
      "profile_name profile_picture biography follower verified"
    )
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(30);

  const recentSongs2 = await recentlyPlayed.populate(recentSongs1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const recentSongs = await recentlyPlayed.populate(recentSongs2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(recentSongs);
});

module.exports = router;
