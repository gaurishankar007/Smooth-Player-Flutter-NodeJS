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
    .find({ user: req.userInfo._id })
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
    .find({ user: req.userInfo._id })
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(100);

  const recentlyPlayedSongs4 = await recentlyPlayed.populate(
    recentlyPlayedSongs3,
    {
      path: "song.album",
      select: "title artist album_image",
    }
  );

  const recentlyPlayedSong5 = await recentlyPlayed.populate(
    recentlyPlayedSongs4,
    {
      path: "song.album.artist",
      select: "profile_name profile_picture biography follower verified",
    }
  );

  const albumIds = [];
  const albumIdsCount = [];

  for (let i = 0; i < recentlyPlayedSong5.length; i++) {
    if (albumIds.includes(recentlyPlayedSong5[i].song.album._id) === false) {
      albumIds.push(recentlyPlayedSong5[i].song.album._id);
      albumIdsCount.push(1);
    } else {
      const albumIndex = albumIds.indexOf(
        recentlyPlayedSong5[i].song.album._id
      );
      albumIdsCount[albumIndex] = albumIdsCount[albumIndex] + 1;
    }
  }
  const sortedAlbumsIdsCount = albumIdsCount.sort();
  const sortedAlbumIds = []

  for (let i = 0; i < albumIds.length; i++) {
    if (sortedAlbumIds.length <= 6){
      const albumIndex = albumIds.indexOf(sortedAlbumsIdsCount[i]);
      sortedAlbumIds.push(albumIds[albumIndex]);
    }
  }


  console.log(albumIds);
  console.log(albumIdsCount);
  console.log(sortedAlbumIds);
  console.log(sortedAlbumsIdsCount);

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
    nR: newReleases,
    pF: featuredplaylists,
    pA: albums,
    pAr: artist,
  });
});

module.exports = router;
