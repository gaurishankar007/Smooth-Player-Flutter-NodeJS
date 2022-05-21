const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const recentlyPlayed = require("../model/RecentlyPlayedModel");

router.post("/add/recentSong", auth.verifyUser, (req, res)=> {
    new recentlyPlayed({
        user: req.userInfo._id,
        song: mongoose.Types.ObjectId(req.body.songId)
    }).save().then(()=> {
        res.status(201).send({resM: "Song added to recently played list."});
    });
});

router.get("/view/recentSong", auth.verifyUser, async (req, res)=> {
    const recentSongs = await recentlyPlayed.find({user: req.userInfo._id})
    .populate("user", "profile_name")
    .populate("song")
    .sort({createdAt: -1})
    .limit(30);

    const recentSongs1 = await recentlyPlayed.populate(recentSongs, {
        path: "song.album",
        select: "title artist album_image"
    });

    const recentSongs2 = await recentlyPlayed.populate(recentSongs1, {
        path: "song.album.artist",
        select: "profile_name"
    });

    res.send(recentSongs2);
});

module.exports = router;