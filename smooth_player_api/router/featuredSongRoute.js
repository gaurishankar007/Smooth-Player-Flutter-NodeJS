const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const musicFile = require('../setting/songSetting');
const album = require('../model/albumModel');
const song = require('../model/songModel');
const mongoose = require('mongoose');
const fs = require("fs");

router.post("/upload/featuredSong", auth.verifyAdmin, musicFile.array('song_file', 2), function(req, res){
    if(req.files.length==0) {
        res.status(400).send({resM: "Unsupported file format."});
        return;
    }
    else if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the song title."});
        return;        
    }

    var music_file = "";

    for(i=0; i<req.files.length; i++) {
        if(req.files[i].filename.split(".").pop() === "png" || req.files[i].filename.split(".").pop() === "jpeg" || req.files[i].filename.split(".").pop() === "jpg")  { 
            cover_image=req.files[i].filename;
        } else if(req.files[i].filename.split(".").pop() === "mp3" || req.files[i].filename.split(".").pop() === "mp4") {
            music_file=req.files[i].filename;
        }
    }
    
    const newfeaturedSong = new featuredsong({
        album: mongoose.Types.ObjectId(req.body.albumId),
        music_file: music_file,
        
    }); 

    newfeaturedSong.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + "featured song uploaded."});        
    });
});



module.exports = router;