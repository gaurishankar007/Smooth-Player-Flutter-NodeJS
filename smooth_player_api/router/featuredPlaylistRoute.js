const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const featuredPlaylist = require('../model/featurePlaylistModel');
const featuredSong = require('../model/featureSongModel');
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

    const newFeaturedPlaylist = new featuredPlaylist({
        title: req.body.title,
        featured_playlist_image: req.file.filename
    })

    newFeaturedPlaylist.save().then(()=> {
        res.status(201).send({resM: "'" + req.body.title + "'" + " featured playlist created."});
    });
    
});

router.get("/view/featuredPlaylist", auth.verifyAdmin, async (req, res)=> {
    const featuredPlaylists = await featuredPlaylist.find()
    .sort({createdAt: -1});
    res.send(featuredPlaylists);
});

router.post("/search/featuredPlaylist", auth.verifyAdmin, async (req, res)=> {
    const playlistTitle =   {title: { $regex: req.body.title, $options: "i" }}; 
    const playlists = await featuredPlaylist.find(playlistTitle).limit(20);   
    res.send(playlists); 
});

router.delete("/delete/featuredPlaylist", auth.verifyAdmin, async (req, res)=> {
    const featuredSongs = await featuredSong.find({album: req.body.featuredPlaylistId});
    const featuredPlaylistData = await featuredPlaylist.findOne({_id: req.body.featuredPlaylistId});

    for(i=0; i<featuredSongs.length; i++) {
        featuredSong.findByIdAndDelete(featuredSongs[i]["_id"]).then();   
    }
      
    fs.unlinkSync(`../smooth_player_api/upload/image/featuredPlaylist/${featuredPlaylistData["featured_playlist_image"]}`);        
    featuredPlaylist.findByIdAndDelete(featuredPlaylistData["_id"]).then(()=> {
        res.send({resM: "Featured Playlist has been deleted."});
    });   
});

module.exports = router;