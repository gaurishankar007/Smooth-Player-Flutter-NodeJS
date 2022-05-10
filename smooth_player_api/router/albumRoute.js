const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const album = require('../model/albumModel');


const albumUpload = require("../setting/albumSetting")

router.post("/upload/album", auth.verifyUser, albumUpload.single("album_image"), function(req, res){
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }

    const newAlbum = new album({
        title: req.body.title,
        artist: req.userInfo._id,
        album_image: req.file.filename
    })

    newAlbum.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " album created."});
    });
});



module.exports = router;