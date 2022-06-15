const express = require("express");
const router = new express.Router();
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

router.put("/rename/playlist", auth.verifyUser, (req, res) => {
  const playlistTitle = req.body.playlistTitle;
  const playlistId = req.body.playlistId;

  playlist
    .findOneAndUpdate({ _id: playlistId }, { title: playlistTitle })
    .then(() => {
      res.send({ resM: "Playlist renamed." });
    });
});

router.delete("/delete/playlist", auth.verifyUser, (req, res) => {
  const playlistTitle = req.body.playlistTitle;
  const playlistId = req.body.playlistId;

  playlist.findByIdAndDelete(playlistId).then(() => {
    res.send({ resM: playlistTitle + " playlist deleted." });
  });
});

router.get("/view/playlists", auth.verifyUser, async (req, res) => {
  const playlists = await playlist
    .find({ user: req.userInfo._id })
    .sort({ createdAt: -1 });

  res.send(playlists);
});

module.exports = router;
