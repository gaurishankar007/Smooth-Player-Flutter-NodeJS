const mongoose = require("mongoose")

const albumSchema = new mongoose.Schema({
    title:{
        type: String,
        trim: true,

    },
    artist:{
        type:mongoose.Schema.ObjectId,
        ref: "user",
    },
    album_image:{
        type: String
    }
    
},
{
    timestamps: true
}
)


module.exports = mongoose.model("album", albumSchema);
