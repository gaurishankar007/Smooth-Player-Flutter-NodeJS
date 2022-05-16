const express = require('express');
const mongoose = require("mongoose");
const router = new express.Router();
const auth = require('../authentication/auth');
const featuredSong = require('../model/featureSongModel');

router.delete("/delete/featuredPlaylistSong", auth.verifyUser, async (req, res)=> {
    featuredSong.findByIdAndDelete(req.body.featuredSongId).then(()=> {
        res.send({resM: "Featured Playlist Song has been deleted."});
    });   
});


router.post("/upload/featuredSong", auth.verifyAdmin, async(req, res)=> {
    const newFeaturedSong = new playlist({
        featuredPlaylist: mongoose.Types.ObjectId(req.body.featuredPlaylistId),
        song: mongoose.Types.ObjectId(req.body.songId)
    })

    newFeaturedSong.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " featured song added."});
    }); 
})

module.exports = router;