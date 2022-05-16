const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const featuredSong = require('../model/featureSongModel');

router.delete("/delete/featuredPlaylistSong", auth.verifyUser, async (req, res)=> {
    featuredSong.findByIdAndDelete(req.body.featuredSongId).then(()=> {
        res.send({resM: "Featured Playlist Song has been deleted."});
    });   
});

module.exports = router;