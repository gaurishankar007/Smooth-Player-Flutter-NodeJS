const featuredPlaylist = require("../model/featurePlaylistModel")
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

describe('featured playlist schema test', ()=> {

    // insert
    it('featured playlist insert testing', ()=> {
        const newfeaturedPlaylist = {
            "title": "test",
            "featured_playlist_image": "featuredplaylist.jpg",
            
        } 
        return featuredPlaylist.create(newfeaturedPlaylist).then((playlistData)=>{
            expect(playlistData.title).toEqual("test")
            expect(playlistData.featured_playlist_image).toEqual("featuredplaylist.jpg")
            
        })
    })

     // update
     it('featured playlist update testing', ()=> {
        return featuredPlaylist.updateOne({_id: Object("6281b82f09cfa23d88f3811a")}, 
        {$set: {title: "New test"}})
        .then(()=> {
           return featuredPlaylist.findOne({_id: Object("6281b82f09cfa23d88f3811a")})
            .then((playlistData)=> {                
                expect(playlistData.title).toEqual("New test")
            })
        })
    })
})