const express = require('express');
const router = new express.Router();
const auth = require('../auth/auth');
const album = require('../models/albumModel');

router.post("/upload/album", function(req, res){
    const newAlbum = new album({
        title: req.body.title
    })

    newAlbum.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " album created."});
    });
});

router.get("/view/album", auth.verifyUser, async (req, res)=> {
    const albums = await album.find();
    res.send(albums);
});

router.delete("/delete/album", (req, res)=> {
    album.findByIdAndDelete(req.body.albumId).then(()=> {
        res.send({resM: "Album has been deleted."});
    });
});

module.exports = router;