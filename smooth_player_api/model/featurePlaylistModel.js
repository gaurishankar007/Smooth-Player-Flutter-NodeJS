const mongoose = require("mongoose");

const featuredPlaylistSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      trim: true,
    },
    featured_playlist_image: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("featuredPlaylist", featuredPlaylistSchema);
