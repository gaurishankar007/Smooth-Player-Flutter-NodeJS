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
const featuredPlaylist = mongoose.model("featuredPlaylist", featuredPlaylistSchema);

module.exports = featuredPlaylist;
