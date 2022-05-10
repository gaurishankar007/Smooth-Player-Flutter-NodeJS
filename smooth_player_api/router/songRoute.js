const express = require('express');
const router = new express.Router();
const auth = require('../auth/auth');
const musicFile = require('../upload/setting/music');
const album = require('../models/albumModel');
const song = require('../models/songModel');
const mongoose = require('mongoose');

router.post("/upload/song", musicFile.single('song'), function(req, res){
    if(req.file===undefined) {
        res.status(400).send({resM: "Unsupported file format."});
        return;
    }

    const newSong = new song({
        title: req.body.title,
        album: mongoose.Types.ObjectId(req.body.albumId),
        music: req.file.filename
    }); 

    newSong.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " song uploaded."});        
    });
});

router.post("/view/song", auth.verifyUser, async (req, res)=> {
    const songs = await song.find({album: req.body.albumId}).populate("album");
    res.send(songs);
});

router.delete("/delete/song", (req, res)=> {
    album.findByIdAndDelete(req.body.songId).then(()=> {
        res.send({resM: "Song has been deleted."});
    });
});

module.exports = router;