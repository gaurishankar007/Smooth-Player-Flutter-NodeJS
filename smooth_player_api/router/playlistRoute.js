const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const playlist = require('../model/playlistModel');
const uploadPlaylist = require('../setting/playlistSetting');

router.post("/upload/playlist", auth.verifyAdmin, uploadPlaylist.single("playlist_image"), function(req, res){
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }
    else if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the playlist title."});
        return;        
    }

    const newPlaylist = new playlist({
        title: req.body.title,
        userId: req.adminInfo._id,
        playlist_image: req.file.filename
    })

    newPlaylist.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " playlist created."});
    });
});

router.get("/view/playlist", auth.verifyAdmin, async (req, res)=> {
    const playlists = await playlist.find({userId: req.adminInfo._id}).populate("userId", "profile_name");
    res.send(playlists);
}
);


module.exports = router;