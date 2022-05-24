const mongoose = require("mongoose");
const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const fs = require("fs");
const albumUpload = require("../setting/albumSetting");
const user = require("../model/userModel");
const album = require("../model/albumModel");
const song = require("../model/songModel");

router.post("/view/artistProfile", async (req, res) => {
  const userDetail = await user.findOne({ _id: req.body.artistId });
  const userAlbums = await album.find({ artist: req.body.artistId });

  const  albumIds = [];
  for (let i = 0; i < userAlbums.length; i++) {
    albumIds.push(userAlbums[i]._id);
  }
  
  const albumSongs = await song.find({ album: albumIds, like: { $gte: 1 } }).sort({like:-1}).limit(10);
  const newReleases= await album.find({ artist: req.body.artistId, createdAt: { $gte: new Date(Date.now()-2592000000) } });
  const oldReleases = await album.find({ artist: req.body.artistId, createdAt: { $lt: new Date(Date.now()-2592000000) } });

  res.send({artist: userDetail, popular: albumSongs, new: newReleases, old: oldReleases});
});


module.exports = router;
