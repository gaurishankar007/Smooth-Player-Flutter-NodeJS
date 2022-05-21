const mongoose = require("mongoose");

const recentlyPlayedSchema = new mongoose.Schema(
    {
        user: {
            type: mongoose.Schema.ObjectId, 
            ref: "user"
        },
        song: {
            type: mongoose.Schema.ObjectId,
            ref: "song"
        }
    },
    {
        timestamps: true,
    }
);

const recentlyPlayed = mongoose.model("recentlyPlayed", recentlyPlayedSchema);

module.exports = recentlyPlayed;