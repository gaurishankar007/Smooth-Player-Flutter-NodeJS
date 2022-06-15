const mongoose = require("mongoose");

const albumSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      trim: true,
    },
    artist: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },
    album_image: {
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

const album = mongoose.model("album", albumSchema);

module.exports = album;
