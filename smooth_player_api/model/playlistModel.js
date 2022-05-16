const mongoose = require("mongoose")

const PlaylistSchema = new mongoose.Schema({
    title:{
        type: String,
        trim: true,
    },
    playlist_image:{
        type: String
    },
    userId:{
        type: mongoose.Schema.ObjectId,
        ref: "user",
    }
},
{
timeStamps: true
}
)



module.exports = mongoose.model("playlist", PlaylistSchema);