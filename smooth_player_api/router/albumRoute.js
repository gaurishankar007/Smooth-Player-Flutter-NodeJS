const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const album = require("../model/albumModel");
const song = require("../model/songModel");
const fs = require("fs");
const albumUpload = require("../setting/albumSetting");

router.post(
  "/upload/album",
  auth.verifyUser,
  albumUpload.single("album_image"),
  function (req, res) {
    if (req.file == undefined) {
      return res
        .status(400)
        .send({
          resM: "Invalid image format, only supports png or jpeg image format.",
        });
    } else if (req.body.title.trim() === "") {
      res.status(400).send({ resM: "Provide the album title." });
      return;
    }

    const newAlbum = new album({
      title: req.body.title,
      artist: req.userInfo._id,
      album_image: req.file.filename,
    });

    newAlbum.save().then(() => {
      res
        .status(201)
        .send({ resM: "'" + req.body.title + "'" + " album created." });
    });
  }
);

router.get("/view/album", auth.verifyUser, async (req, res) => {
  const albums = await album
    .find({ artist: req.userInfo._id })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    )
    .sort({ createdAt: -1 });
  res.send(albums);
});

router.delete("/delete/album", auth.verifyUser, async (req, res) => {
  const songs = await song.find({ album: req.body.albumId });
  const albumData = await album.findOne({ _id: req.body.albumId });

  for (i = 0; i < songs.length; i++) {
    song.findByIdAndDelete(songs[i]["_id"]).then();

    if (songs[i]["cover_image"] !== albumData["album_image"]) {
      fs.unlinkSync(
        `../smooth_player_api/upload/image/albumSong/${songs[i]["cover_image"]}`
      );
    }
    fs.unlinkSync(
      `../smooth_player_api/upload/music/${songs[i]["music_file"]}`
    );
  }

  fs.unlinkSync(
    `../smooth_player_api/upload/image/albumSong/${albumData["album_image"]}`
  );
  album.findByIdAndDelete(albumData["_id"]).then(() => {
    res.send({ resM: "Album has been deleted." });
  });
});

router.put(
  "/edit/album/image",
  auth.verifyUser,
  albumUpload.single("album_image"),
  function (req, res) {
    if (req.file == undefined) {
      return res
        .status(400)
        .send({
          resM: "Invalid image format, only supports png or jpeg image format.",
        });
    }

    album.findOne({ _id: req.body.albumId }).then((albumData) => {
      fs.unlinkSync(
        `../smooth_player_api/upload/image/albumSong/${albumData["album_image"]}`
      );
      album
        .updateOne(
          { _id: albumData._id },
          {
            album_image: req.file.filename,
          }
        )
        .then(() => {
          res.send({ resM: "Album Edited" });
        });
    });
  }
);

router.put("/edit/album/title", auth.verifyUser, function (req, res) {
  if (req.body.title.trim() === "") {
    res.status(400).send({ resM: "Provide the album title." });
    return;
  }
  album
    .updateOne(
      { _id: req.body.albumId },
      {
        title: req.body.title,
      }
    )
    .then(() => {
      res.send({ resM: "Album Edited" });
    });
});

module.exports = router;
