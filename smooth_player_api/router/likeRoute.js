const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const like = require("../model/likeModel");
const song = require("../model/songModel");
const album = require("../model/albumModel");
const featuredPlaylist = require("../model/featurePlaylistModel");

router.post("/like/song", auth.verifyUser, (req, res) => {
  const songId = req.body.songId;
  like
    .findOne({
      user: req.userInfo._id,
      song: songId,
    })
    .then((likeData) => {
      if (likeData === null) {
        const newLike = new like({
          user: req.userInfo._id,
          song: mongoose.Types.ObjectId(songId),
        });

        newLike.save().then(() => {
          song.findOne({ _id: songId }).then((songData) => {
            song
              .updateOne({ _id: songId }, { like: songData.like + 1 })
              .then(() => {
                res
                  .status(201)
                  .send({ resM: "You liked " + req.body.songTitle });
              });
          });
        });
      } else {
        like
          .findOneAndDelete({ user: req.userInfo._id, song: songId })
          .then(() => {
            song.findOne({ _id: songId }).then((songData) => {
              song
                .updateOne({ _id: songId }, { like: songData.like - 1 })
                .then(() => {
                  res.send({ res: "You unliked " + req.body.songTitle });
                });
            });
          });
      }
    });
});

router.post("/like/album", auth.verifyUser, (req, res) => {
  const albumId = req.body.albumId;
  like
    .findOne({
      user: req.userInfo._id,
      album: albumId,
    })
    .then((likeData) => {
      if (likeData === null) {
        const newLike = new like({
          user: req.userInfo._id,
          album: mongoose.Types.ObjectId(albumId),
        });

        newLike.save().then(() => {
          album.findOne({ _id: albumId }).then((albumData) => {
            album
              .updateOne({ _id: albumId }, { like: albumData.like + 1 })
              .then(() => {
                res
                  .status(201)
                  .send({ resM: "You liked " + req.body.albumTitle });
              });
          });
        });
      } else {
        like
          .findOneAndDelete({ user: req.userInfo._id, album: albumId })
          .then(() => {
            album.findOne({ _id: albumId }).then((albumData) => {
              album
                .updateOne({ _id: albumId }, { like: albumData.like - 1 })
                .then(() => {
                  res.send({ res: "You unliked " + req.body.albumTitle });
                });
            });
          });
      }
    });
});

router.post("/like/featuredPlaylist", auth.verifyUser, (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  like
    .findOne({
      user: req.userInfo._id,
      featuredPlaylist: featuredPlaylistId,
    })
    .then((likeData) => {
      if (likeData === null) {
        const newLike = new like({
          user: req.userInfo._id,
          featuredPlaylist: mongoose.Types.ObjectId(featuredPlaylistId),
        });

        newLike.save().then(() => {
          featuredPlaylist
            .findOne({ _id: featuredPlaylistId })
            .then((featuredPlaylistData) => {
              featuredPlaylist
                .updateOne(
                  { _id: featuredPlaylistId },
                  { like: featuredPlaylistData.like + 1 }
                )
                .then(() => {
                  res
                    .status(201)
                    .send({
                      resM: "You liked " + req.body.featuredPlaylistTitle,
                    });
                });
            });
        });
      } else {
        like
          .findOneAndDelete({
            user: req.userInfo._id,
            featuredPlaylist: featuredPlaylistId,
          })
          .then(() => {
            featuredPlaylist
              .findOne({ _id: featuredPlaylistId })
              .then((featuredPlaylistData) => {
                featuredPlaylist
                  .updateOne(
                    { _id: featuredPlaylistId },
                    { like: featuredPlaylistData.like - 1 }
                  )
                  .then(() => {
                    res.send({
                      res: "You unliked " + req.body.featuredPlaylistTitle,
                    });
                  });
              });
          });
      }
    });
});

module.exports = router;
