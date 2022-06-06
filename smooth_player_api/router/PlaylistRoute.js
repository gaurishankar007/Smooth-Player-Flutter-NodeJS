const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const playlist = require("../model/playlistModel");

router.post("/create/playlist", auth.verifyUser, (req, res) => {
  const title = req.body.title;

  if (title.trim() === "") {
    return res.status(400).send({ resM: "Provide playlist name." });
  }

  const newPlaylist = new playlist({
    user: req.userInfo._id,
    title: title,
  });

  newPlaylist.save().then(() => {
    res.status(201).send({ resM: title + " playlist created." });
  });
});

router.delete("/delete/playlist", auth.verifyUser, (req, res) => {
  const title = req.body.title;
  const playlistId = req.body.playlistId;

  playlist.findByIdAndDelete(playlistId).then(() => {
    res.send({ resM: title + " playlist deleted." });
  });
});

module.exports = router;
