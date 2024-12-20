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
    it('featured playlist insert testing', async ()=> {
        const newFeaturedPlaylist = {
            "title": "test",
            "featured_playlist_image": "featuredPlaylist.jpg",            
        } 

        const playlistData = await featuredPlaylist.create(newFeaturedPlaylist)
        expect(playlistData.title).toEqual("test")
        expect(playlistData.featured_playlist_image).toEqual("featuredPlaylist.jpg")
    })

    // update
    it('featured playlist update testing', ()=> {
        return featuredPlaylist.updateOne({_id: Object("62a6b84a63f77ea8bb65eb6b")}, 
        {$set: {title: "New test"}})
        .then(()=> {
           return featuredPlaylist.findOne({_id: Object("62a6b84a63f77ea8bb65eb6b")})
            .then((playlistData)=> {                
                expect(playlistData.title).toEqual("New test")
            })
        })
    })
})