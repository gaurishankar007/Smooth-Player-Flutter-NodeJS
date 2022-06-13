const multer = require("multer");

const storageNavigation = multer.diskStorage({
    destination: function(req, file, cb) {
        if(file.originalname.split(".").pop() == "png" || file.originalname.split(".").pop() == "jpeg" || file.originalname.split(".").pop() == "jpg")  { 
            cb(null, "../smooth_player_api/upload/image/albumSong");
        } else if(file.originalname.split(".").pop() == "mp3" || file.originalname.split(".").pop() == "mp4") {
            cb(null, "../smooth_player_api/upload/music");
        }
    },
    filename: function(req, file, cb) {
        cb(null, Date.now()+"_"+file.originalname);
    }
});


const filter = function(req, file, cb) {
    if(file.mimetype == "image/png" || file.mimetype=="image/jpeg" || file.mimetype == "audio/mpeg" || file.mimetype=="audio/mp4" || file.mimetype=="application/octet-stream") {
        cb(null, true);
    }
    else {
        cb(null, false);
    }
}

const upload = multer({
    storage: storageNavigation,
    fileFilter: filter
});

module.exports = upload;