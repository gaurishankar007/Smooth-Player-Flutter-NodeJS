const mongoose = require("mongoose");

const playlistSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("playlist", playlistSchema);
