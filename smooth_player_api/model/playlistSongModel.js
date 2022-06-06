const mongoose = require("mongoose");

const playlistSongSchema = new mongoose.Schema(
  {
    playlist: {
      type: mongoose.Schema.ObjectId,
      ref: "playlist",
    },
    song: {
      type: mongoose.Schema.ObjectId,
      ref: "song",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("playlistSong", playlistSongSchema);
