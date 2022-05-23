const song = require("../model/songModel")
const mongoose = require("mongoose")

const url = "mongodb://localhost:27017/smooth_player_test"

beforeAll(async ()=> {
    mongoose.connect(url, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
})

afterAll(async ()=> {
    await mongoose.connection.close()
})

describe('song schema test', ()=> {

    // insert
    it('song insert testing', ()=> {
        const newSong = {
            "title": "test",
            "album": "627b62e2a6487bbb7d0a85ed",
            "music_file": "song.mp3",
            "cover_image": "cover.jpg",
            
        } 
        return song.create(newSong).then((songData)=>{
            expect(songData.title).toEqual("test")            
            expect(songData.album).toEqual(mongoose.Types.ObjectId("627b62e2a6487bbb7d0a85ed"))
            expect(songData.music_file).toEqual("song.mp3")
            expect(songData.cover_image).toEqual("cover.jpg")
        })
    })

    // update
    it('song update testing', ()=> {
        return song.updateOne({_id: Object("627b64cf2882e8eed1e7576c")}, 
        {$set: {title: "New test"}})
        .then(()=> {
           return song.findOne({_id: Object("627b64cf2882e8eed1e7576c")})
            .then((songData)=> {                
                expect(songData.title).toEqual("New test")
            })
        })
    })    
})