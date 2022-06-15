const mongoose = require("mongoose");

const followSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },
    artist: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },
  },
  {
    timestamps: true,
  }
);

const follow = mongoose.model("follow", followSchema);

module.exports = follow;
