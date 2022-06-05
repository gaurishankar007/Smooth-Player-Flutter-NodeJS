const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const follow = require("../model/followModel");

router.post("/follow/artist", auth.verifyUser, (req, res) => {
  const newFollow = new follow({
    user: req.userInfo._id,
    artist: mongoose.Types.ObjectId(req.body.artistId),
  });

  newFollow.save().then(() => {
    res.status(201).send({ resM: "You followed " + req.body.artistName });
  });
});

router.delete("/unFollow/artist", auth.verifyUser, (req, res) => {
  follow
    .findOneAndDelete({ user: req.userInfo._id, artist: req.body.artistId })
    .then(() => {
      res.send({ res: "You unfollowed " + req.body.artistName });
    });
});

module.exports = router;
