const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const featuredPlaylist = require('../model/featurePlaylistModel');
// const featuredSong = require('../model/featureSongModel');
const fs = require("fs");
const featuredPlaylistUpload = require("../setting/featuredPlaylistSetting");



router.post("/upload/featuredPlaylist", auth.verifyAdmin, featuredPlaylistUpload.single("featured_playlist_image"), function(req, res){
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }
    else if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the album title."});
        return;        
    }

    const newfeaturedPlaylist = new featuredPlaylist({
        title: req.body.title,
        featured_playlist_image: req.file.filename
    })

    newfeaturedPlaylist.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " featured playlist created."});
    });
    
});


module.exports = router;