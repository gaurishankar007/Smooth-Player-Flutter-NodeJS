const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const follow = require("../model/followModel");

router.post("/follow/artist", auth.verifyUser, (req, res) => {
  const artistId = req.body.artistId;
  const artistName = req.body.artistName;
  follow
    .findOne({
      user: req.userInfo._id,
      artist: artistId,
    })
    .then((followData) => {
      if (followData === null) {
        const newFollow = new follow({
          user: req.userInfo._id,
          artist: mongoose.Types.ObjectId(req.body.artistId),
        });

        newFollow.save().then(() => {
          res.status(201).send({ resM: "You followed " + artistName });
        });
      } else {
        follow
          .findOneAndDelete({
            user: req.userInfo._id,
            artist: req.body.artistId,
          })
          .then(() => {
            res.send({ resM: "You unfollowed " + artistName });
          });
      }
    });
});

router.post("/follow/checkArtist", auth.verifyUser, (req, res) => {
  const artistId = req.body.artistId;
  follow
    .findOne({
      user: req.userInfo._id,
      artist: artistId,
    })
    .then((followData) => {
      if (followData === null) {
        res.send(false);
      } else {
        res.send(true);
      }
    });
});

router.get("/view/followedArtists", auth.verifyUser, async (req, res) => {
  const followedArtists = await follow
    .find({ user: req.userInfo._id })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    );
  res.send(followedArtists);
});

module.exports = router;
