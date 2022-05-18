const express = require('express');
const router = new express.Router();
const auth = require('../authentication/auth');
const musicFile = require('../setting/songSetting');
const album = require('../model/albumModel');
const song = require('../model/songModel');
const mongoose = require('mongoose');
const fs = require("fs");

router.post("/upload/albumSong", auth.verifyUser, musicFile.array('song_file', 2), function(req, res){
    if(req.files.length==0) {
        res.status(400).send({resM: "Unsupported file format."});
        return;
    }
    else if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the song title."});
        return;        
    }

    var music_file = "";
    var cover_image = "";

    for(i=0; i<req.files.length; i++) {
        if(req.files[i].filename.split(".").pop() === "png" || req.files[i].filename.split(".").pop() === "jpeg" || req.files[i].filename.split(".").pop() === "jpg")  { 
            cover_image=req.files[i].filename;
        } else if(req.files[i].filename.split(".").pop() === "mp3" || req.files[i].filename.split(".").pop() === "mp4") {
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
    else if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the song title."});
        return;        
    }

    var music_file = "";
    var cover_image = "";

    for(i=0; i<req.files.length; i++) {
        if(req.files[i].filename.split(".").pop() === "png" || req.files[i].filename.split(".").pop() === "jpeg" || req.files[i].filename.split(".").pop() === "jpg")  { 
            cover_image=req.files[i].filename;
        } else if(req.files[i].filename.split(".").pop() === "mp3" || req.files[i].filename.split(".").pop() === "mp4") {
            music_file=req.files[i].filename;
        }
    }

    const newAlbum = await album.create({
        title: req.body.title,
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

router.post("/view/song", auth.verifyUser, async (req, res)=> {
    const songs = await song.find({album: req.body.albumId}).populate("album").sort({created_at: -1});
    const songs1 = await song.populate(songs, {
        path: "album.artist",
        select: "profile_name"
    });
    res.send(songs1);
});

router.delete("/delete/song", auth.verifyUser, (req, res)=> {
    song.findOne({_id: req.body.songId}).then((songData)=>{
        album.findOne({_id: songData.album}).then((albumData)=> {
            if(songData.cover_image!==albumData.album_image) {
                fs.unlinkSync(`../smooth_player_api/upload/image/album_song/${songData.cover_image}`);
            }
            fs.unlinkSync(`../smooth_player_api/upload/music/${songData.music_file}`);
            song.findByIdAndDelete(songData._id).then(()=> {
                res.send({resM: "song deleted."});
            });   
        });     
    });
} );


router.put("/edit/song/title", auth.verifyUser, (req, res)=> {
    if(req.body.title.trim()==="") {
        res.status(400).send({resM: "Provide the song title."});
        return;        
    }
   song.updateOne({_id: req.body.songId}, {title: req.body.title}).then(()=> {
        res.send({resM: "Song Edited."});
    });  
} );

router.put("/edit/song/image", auth.verifyUser, musicFile.single('song_file'), (req, res)=> {
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }
    song.findOne( { _id: req.body.songId } ).then( ( songData ) =>{
        fs.unlinkSync( `../smooth_player_api/upload/image/album_song/${ songData.cover_image }` );   
        song.updateOne( { _id: songData._id }, { cover_image: req.file.filename } ).then( () =>{
            res.send({resM: "Song Edited."});
        });
    });
});

router.post("/search/songByTitle", auth.verifyAdmin, async (req, res)=> {
    if(req.body.title==="") {
        return res.send([]);
    }
    const songTitle =  {title: { $regex: req.body.title, $options: "i" }}; 

    const songs = await song.find(songTitle).populate("album")  
    const songs1 = await song.populate(songs, {
        path: "album.artist",
        select: "profile_name"
    });
    res.send(songs1); 
});

module.exports = router;