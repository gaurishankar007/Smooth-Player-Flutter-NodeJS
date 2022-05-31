const mongoose = require("mongoose");
const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");

const user = require("../model/userModel");
const album = require("../model/albumModel");
const song = require("../model/songModel");

router.post("/view/artistProfile", auth.verifyUser, async (req, res) => {
  const userDetail = await user.findOne({ _id: req.body.artistId });
  const userAlbums = await album.find({ artist: req.body.artistId });

  const albumIds = [];
  for (let i = 0; i < userAlbums.length; i++) {
    albumIds.push(userAlbums[i]._id);
  }

  const albumSongs1 = await song
    .find({ album: albumIds, like: { $gte: 1 } })
    .sort({ like: -1 })
    .limit(10)
    .populate("album");

  const albumSongs = await song.populate(albumSongs1, {
    path: "album.artist",
    select: "profile_name",
  });

  const newReleases = await album
    .find({
      artist: req.body.artistId,
      createdAt: { $gte: new Date(Date.now() - 2592000000) },
    })
    .populate("artist", "profile_name");

  const oldReleases = await album
    .find({
      artist: req.body.artistId,
      createdAt: { $lt: new Date(Date.now() - 2592000000) },
    })
    .populate("artist", "profile_name");

  res.send({
    artist: userDetail,
    popularSong: albumSongs,
    newAlbum: newReleases,
    oldAlbum: oldReleases,
  });
});

router.post("/search/artist", auth.verifyAdmin, async (req, res) => {
  if (req.body.profile_name.trim() === "") {
    return res.send([]);
  }
  const artistName = {
    profile_name: { $regex: req.body.profile_name, $options: "i" },
    verified: true,
  };
  const artists = await user.find(artistName);
  res.send(artists);
});

router.get("/view/popularArtist", auth.verifyAdmin, async (req, res) => {
  const popularArtist = await user
    .find({ admin: true, verified: true })
    .sort({ follower: -1 })
    .limit(20);
  res.send(popularArtist);
});

router.post("/admin/artistProfile", auth.verifyAdmin, async (req, res) => {
  const userDetail = await user.findOne({ _id: req.body.artistId });
  const userAlbums = await album.find({ artist: req.body.artistId });

  const albumIds = [];
  for (let i = 0; i < userAlbums.length; i++) {
    albumIds.push(userAlbums[i]._id);
  }

  const albumSongs1 = await song
    .find({ album: albumIds, like: { $gte: 1 } })
    .sort({ like: -1 })
    .limit(10)
    .populate("album");

  const albumSongs = await song.populate(albumSongs1, {
    path: "album.artist",
    select: "profile_name",
  });

  const newReleases = await album
    .find({
      artist: req.body.artistId,
      createdAt: { $gte: new Date(Date.now() - 2592000000) },
    })
    .populate("artist", "profile_name");

  const oldReleases = await album
    .find({
      artist: req.body.artistId,
      createdAt: { $lt: new Date(Date.now() - 2592000000) },
    })
    .populate("artist", "profile_name");

  res.send({
    artist: userDetail,
    popularSong: albumSongs,
    newAlbum: newReleases,
    oldAlbum: oldReleases,
  });
});

module.exports = router;
