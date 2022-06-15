const mongoose = require("mongoose");

const tokenSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },

    password: {
        type: String
    },

    token: {
      type: Number,
    },
  },
  {
    timestamps: true,
  }
);

const token = mongoose.model("token", tokenSchema);

module.exports = token;
