const mongoose = require("mongoose");
const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const user = require("../model/userModel");
const album = require("../model/albumModel");
const recentlyPlayed = require("../model/RecentlyPlayedModel");
const featuredPlaylist = require("../model/featurePlaylistModel");
const follow = require("../model/followModel");

router.post("/load/home", auth.verifyUser, async (req, res) => {
  const userId = req.body.userId;

  const recentlyPlayedSongs1 = await recentlyPlayed
    .find({ user: userId })
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(30);

  const recentlyPlayedSongs2 = await recentlyPlayed.populate(
    recentlyPlayedSongs1,
    {
      path: "song.album",
      select: "title artist album_image",
    }
  );

  const recentlyPlayedSongs = await recentlyPlayed.populate(
    recentlyPlayedSongs2,
    {
      path: "song.album.artist",
      select: "profile_name profile_picture biography follower verified",
    }
  );

  const recentlyPlayedSongs3 = await recentlyPlayed
    .find({ user: userId })
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(100);

  const featuredplaylists = await featuredPlaylist
    .find()
    .sort({ like: -1 })
    .limit(10);
  const albums = await album.find().sort({ like: -1 }).limit(10);
  const artist = await user.find().sort({ follower: -1 }).limit(10);

  const followedArtist = [];
  const followings = await follow.find({ user: req.userInfo._id });
  for (let i = 0; i < followings.length; i++) {
    followedArtist.push(followings[i].artist);
  }
  const newReleases = await album
    .find({
      artist: followedArtist,
      createdAt: { $gte: new Date(Date.now() - 2592000000) },
    })
    .sort({ createdAt: -1 });

  res.send({
    rPs: recentlyPlayedSongs,
    pF: featuredplaylists,
    pA: albums,
    pAr: artist,
    nR: newReleases,
  });
});

module.exports = router;
