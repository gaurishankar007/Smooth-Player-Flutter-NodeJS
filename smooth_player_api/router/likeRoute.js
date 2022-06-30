const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const like = require("../model/likeModel");
const song = require("../model/songModel");
const album = require("../model/albumModel");
const featuredPlaylist = require("../model/featurePlaylistModel");

// like song feature
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
                res.send({ resM: "You liked " + req.body.songTitle });
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
                  res.send({ resM: "You unliked " + req.body.songTitle });
                });
            });
          });
      }
    });
});

// check like song in boolean
router.post("/like/checkSong", auth.verifyUser, (req, res) => {
  const songId = req.body.songId;
  like
    .findOne({
      user: req.userInfo._id,
      song: songId,
    })
    .then((likeData) => {
      if (likeData === null) {
        res.send(false);
      } else {
        res.send(true);
      }
    });
});

router.get("/view/likedSongs", auth.verifyUser, async (req, res) => {
  const likedSongs1 = await like
    .find({ user: req.userInfo._id, album: null, featuredPlaylist: null })
    .populate("song")
    .sort({ createdAt: -1 });

  const likedSongs2 = await like.populate(likedSongs1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const likedSongs = await like.populate(likedSongs2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(likedSongs);
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
                res.send({ resM: "You liked " + req.body.albumTitle });
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
                  res.send({ resM: "You unliked " + req.body.albumTitle });
                });
            });
          });
      }
    });
});

router.post("/like/checkAlbum", auth.verifyUser, (req, res) => {
  const albumId = req.body.albumId;
  like
    .findOne({
      user: req.userInfo._id,
      album: albumId,
    })
    .then((likeData) => {
      if (likeData === null) {
        res.send(false);
      } else {
        res.send(true);
      }
    });
});

router.post("/check/albumLikeNum", auth.verifyUser, (req, res) => {
  const albumId = req.body.albumId;
  album.findOne({ _id: albumId }).then((albumData) => {
    res.send(albumData.like.toString());
  });
});

router.get("/view/likedAlbums", auth.verifyUser, async (req, res) => {
  const likedAlbums1 = await like
    .find({ user: req.userInfo._id, song: null, featuredPlaylist: null })
    .populate("album")
    .sort({ createdAt: -1 });

  const likedAlbums = await like.populate(likedAlbums1, {
    path: "album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(likedAlbums);
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
                  res.send({
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
                      resM: "You unliked " + req.body.featuredPlaylistTitle,
                    });
                  });
              });
          });
      }
    });
});

router.post("/like/checkFeaturedPlaylist", auth.verifyUser, (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  like
    .findOne({
      user: req.userInfo._id,
      featuredPlaylist: featuredPlaylistId,
    })
    .then((likeData) => {
      if (likeData === null) {
        res.send(false);
      } else {
        res.send(true);
      }
    });
});

router.post("/check/featuredPlaylistLikeNum", auth.verifyUser, (req, res) => {
  const featuredPlaylistId = req.body.featuredPlaylistId;
  featuredPlaylist
    .findOne({ _id: featuredPlaylistId })
    .then((featuredPlaylistData) => {
      res.send(featuredPlaylistData.like.toString());
    });
});

router.get(
  "/view/likedFeaturedPlaylists",
  auth.verifyUser,
  async (req, res) => {
    const likedFeaturedPlaylists = await like
      .find({ user: req.userInfo._id, song: null, album: null })
      .populate("featuredPlaylist")
      .sort({ createdAt: -1 });

    res.send(likedFeaturedPlaylists);
  }
);

module.exports = router;
