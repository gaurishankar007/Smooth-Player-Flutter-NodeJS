const mongoose = require("mongoose");

const likeSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },
    song: {
      type: mongoose.Schema.ObjectId,
      ref: "song",
      default: null,
    },
    album: {
      type: mongoose.Schema.ObjectId,
      ref: "album",
      default: null,
    },
    featuredPlaylist: {
      type: mongoose.Schema.ObjectId,
      ref: "featuredPlaylist",
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

const like = mongoose.model("like", likeSchema);

module.exports = like;
