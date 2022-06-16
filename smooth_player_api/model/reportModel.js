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
  },
  {
    timestamps: true,
  }
);

const report = mongoose.model("report", reportSchema);

module.exports = report;
