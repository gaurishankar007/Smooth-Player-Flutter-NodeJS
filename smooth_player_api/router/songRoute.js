const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const musicFile = require('../setting/songSetting');
const album = require('../model/albumModel');
const song = require('../model/songModel');
const mongoose = require('mongoose');

router.post("/upload/albumSong",auth.verifyUser, musicFile.array('song_file', 2), function(req, res){
    if(req.files.length==0) {
        res.status(400).send({resM: "Unsupported file format."});
        return;
    }

    var music_file = "";
    var cover_image = "";

    for(i=0; i<req.files.length; i++) {
        if(req.files[i].mimetype == "image/png" || req.files[i].mimetype == "image/jpeg") {            
            cover_image=req.files[i].filename;
        } else if(req.files[i].mimetype == "audio/mpeg" || req.files[i].mimetype=="audio/mp4") {
            music_file=req.files[i].filename;
        }
    }
    
    const newSong = new song({
        title: req.body.title,
        album: mongoose.Types.ObjectId(req.body.albumId),
        music_file: music_file,
        cover_image: cover_image,
    }); 

    newSong.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " song uploaded."});        
    });
});

router.post("/upload/singleSong", auth.verifyUser, musicFile.array('song_file', 2), async function(req, res)  {
    if(req.files.length==0) {
        res.status(400).send({resM: "Unsupported file format."});
        return;
    }

    var music_file = "";
    var cover_image = "";

    for(i=0; i<req.files.length; i++) {
        if(req.files[i].mimetype == "image/png" || req.files[i].mimetype == "image/jpeg") {            
            cover_image=req.files[i].filename;
        } else if(req.files[i].mimetype == "audio/mpeg" || req.files[i].mimetype=="audio/mp4") {
            music_file=req.files[i].filename;
        }
    }

    const title = req.body.title;

    const newAlbum = await album.create({
        title: req.title,
        artist: req.userInfo._id,
        album_image: cover_image,
    })
    
    const newSong = new song({
        title: req.body.title,
        album: newAlbum._id,
        music_file: music_file,
        cover_image: cover_image,
    }); 

    newSong.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " song uploaded."});        
    });
});



module.exports = router;