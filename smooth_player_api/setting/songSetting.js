const multer = require("multer");

const storageNavigation = multer.diskStorage({
  destination: function (req, file, cb) {
    const fileMimeType = file.mimetype;
    const fileType = file.originalname.split(".").pop();

    if (
      fileMimeType == "image/png" ||
      fileMimeType == "image/jpeg" ||
      fileMimeType == "audio/mpeg" ||
      fileMimeType == "audio/mp4"
    ) {
      if (fileMimeType == "image/png" || fileMimeType == "image/jpeg") {
        cb(null, "../smooth_player_api/upload/image/albumSong");
      } else if (fileMimeType == "audio/mpeg" || fileMimeType == "audio/mp4") {
        cb(null, "../smooth_player_api/upload/music");
      }
    } else if (fileMimeType == "application/octet-stream") {
      if (fileType == "png" || fileType == "jpeg" || fileType == "jpg") {
        cb(null, "../smooth_player_api/upload/image/albumSong");
      } else if (fileType == "mp3" || fileType == "mp4" || fileType == "m4a") {
        cb(null, "../smooth_player_api/upload/music");
      }
    }
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "_" + file.originalname);
  },
});

const filter = function (req, file, cb) {
  const fileMimeType = file.mimetype;
  const fileType = file.originalname.split(".").pop();

  if (
    fileMimeType == "image/png" ||
    fileMimeType == "image/jpeg" ||
    fileMimeType == "audio/mpeg" ||
    fileMimeType == "audio/mp4"
  ) {
    cb(null, true);
  } else if (fileMimeType == "application/octet-stream") {
    if (
      fileType == "png" ||
      fileType == "jpeg" ||
      fileType == "jpg" ||
      fileType == "mp3" ||
      fileType == "mp4" ||
      fileType == "m4a"
    ) {
      cb(null, true);
    } else {
      cb(null, false);
    }
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storageNavigation,
  fileFilter: filter,
});

module.exports = upload;
