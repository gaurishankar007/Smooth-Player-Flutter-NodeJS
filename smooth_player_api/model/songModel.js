const mongoose = require("mongoose")

const songSchema = new mongoose.Schema({
    title: {
        type: String,
        trim:true,

    },
    album:{
        type: mongoose.Schema.ObjectId,
        ref: "album",

    },
    music_file:{
        type:String
    },
    cover_image:{
        type:String,
    },
    like:{
        type: Number,
    }

},
{
    timestamps: true
})

module.exports = mongoose.model("song", songSchema);