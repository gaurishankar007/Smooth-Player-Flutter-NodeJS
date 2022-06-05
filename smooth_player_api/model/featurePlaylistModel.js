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
    like: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("featuredPlaylist", featuredPlaylistSchema);
