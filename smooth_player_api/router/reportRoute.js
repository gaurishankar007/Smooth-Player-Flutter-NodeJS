const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const report = require("../model/reportModel");
const album = require("../model/albumModel");
const song = require("../model/songModel");
const user = require("../model/userModel");
const fs = require("fs");

router.post("/report/song", auth.verifyUser, (req, res) => {
  const reportFor = req.body.reportFor;
  if (reportFor === undefined) {
    return res.status(400).send({ resM: "Select at least one reason." });
  }

  const newReport = new report({
    user: req.userInfo._id,
    song: mongoose.Types.ObjectId(req.body.songId),
    reportFor: reportFor,
  });

  newReport.save().then(() => {
    res.status(201).send({ resM: "Your report has been submitted." });
  });
});

router.delete("/report/delete", auth.verifyAdmin, (req, res) => {
  report.deleteOne({ _id: req.body.reportId }).then(() => {
    res.send({ resM: "Report has been deleted." });
  });
});

router.delete("/report/deleteSong", auth.verifyUser, (req, res) => {
  song.findOne({ _id: req.body.songId }).then((songData) => {
    album.findOne({ _id: songData.album }).then((albumData) => {
      if (songData.cover_image !== albumData.album_image) {
        fs.unlinkSync(
          `../smooth_player_api/upload/image/albumSong/${songData.cover_image}`
        );
      }
      fs.unlinkSync(`../smooth_player_api/upload/music/${songData.music_file}`);
      song.findByIdAndDelete(songData._id).then(() => {
        report.deleteMany({ song: songData._id }).then(() => {
          res.send({ resM: "song deleted." });
        });
      });
    });
  });
});

router.delete("/report/songDeleted", auth.verifyAdmin, (req, res) => {
  song.findOne({ _id: req.body.songId }).then((songData) => {
    album.findOne({ _id: songData.album }).then((albumData) => {
      if (songData.cover_image !== albumData.album_image) {
        fs.unlinkSync(
          `../smooth_player_api/upload/image/albumSong/${songData.cover_image}`
        );
      }
      fs.unlinkSync(`../smooth_player_api/upload/music/${songData.music_file}`);
      song.findByIdAndDelete(songData._id).then(() => {
        report.deleteMany({ song: songData._id }).then(() => {
          res.send({ resM: "song deleted." });
        });
      });
    });
  });
});

router.put("/report/warnArtist", auth.verifyAdmin, (req, res) => {
  const reportId = req.body.reportId;
  const message = req.body.message;

  if (message.trim() === "") {
    res.status(400).send({ resM: "Message can not be empty." });
  }

  report.findOneAndUpdate({ _id: reportId }, { message: message }).then(() => {
    res.send({ resM: "Report message sent." });
  });
});

router.get("/report/viewMy", auth.verifyUser, async (req, res) => {
  const albums = await album.find({ artist: req.userInfo._id });
  const songs = await song.find({ album: { $in: albums } });
  const reports1 = await report
    .find({ song: { $in: songs }, })
    .populate(
      "user",
      "profile_name profile_picture biography follower verified"
    )
    .populate("song")
    .sort({ createdAt: -1 });

  const reports2 = await report.populate(reports1, {
    path: "song.album",
    select: "title artist album_image like",
  });

  const reports = await report.populate(reports2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(reports);
});

router.get("/report/check", auth.verifyUser, async (req, res) => {
  const albums = await album.find({ artist: req.userInfo._id });
  const songs = await song.find({ album: { $in: albums } });
  const reports = await report.find({ song: { $in: songs }, });

  var reportExists = false;
  if (reports.length > 0) {
    reportExists = true;
  }

  res.send(reportExists);
});

router.post("/report/viewAll", auth.verifyAdmin, async (req, res) => {
  const reportNum = req.body.reportNum;

  const reports1 = await report
    .find()
    .populate(
      "user",
      "profile_name profile_picture biography follower verified"
    )
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(reportNum);
  const reports2 = await report.populate(reports1, {
    path: "song.album",
    select: "title artist album_image like",
  });
  const reports = await report.populate(reports2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(reports);
});

router.post("/report/search", auth.verifyAdmin, async (req, res) => {
  const artistName = req.body.artistName;
  if (artistName.trim() === "") {
    res.send([]);
  }

  const artists = await user
    .find({ profile_name: { $regex: artistName, $options: "i" } })
    .limit(5);

  const albums = await album.find({ artist: { $in: artists } });
  const songs = await song.find({ album: { $in: albums } });

  const reports1 = await report
    .find({ song: { $in: songs }})
    .populate(
      "user",
      "profile_name profile_picture biography follower verified"
    )
    .populate("song")
    .sort({ createdAt: -1 });
  const reports2 = await report.populate(reports1, {
    path: "song.album",
    select: "title artist album_image like",
  });
  const reports = await report.populate(reports2, {
    path: "song.album.artist",
    select: "profile_name profile_picture biography follower verified",
  });

  res.send(reports);
});

module.exports = router;
