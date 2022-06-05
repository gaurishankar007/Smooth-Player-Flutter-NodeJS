const mongoose = require("mongoose");

const reportSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "user",
    },
    song: {
      type: mongoose.Schema.ObjectId,
      ref: "song",
    },
    message: {
      type: String,
      default: "",
    },
    reportFor: [
      {
        type: String,
      },
    ],
    solved: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("report", reportSchema);
