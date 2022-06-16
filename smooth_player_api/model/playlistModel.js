const mongoose = require("mongoose");

const playlistSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },

    title: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

const playlist = mongoose.model("playlist", playlistSchema);

module.exports = playlist;
