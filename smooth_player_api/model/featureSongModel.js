const mongoose = require("mongoose");

const featuredSongSchema = new mongoose.Schema(
  {
    featuredPlaylist: {
      type: mongoose.Schema.ObjectId,
      ref: "featuredPlaylist",
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

const featuredSong = mongoose.model("featuredSong", featuredSongSchema);

module.exports = featuredSong;
