const album = require("../model/albumModel")
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

describe('album schema test', ()=> {

    // insert
    it('album insert testing', async ()=> {
        const newAlbum = {
            "title": "test",
            "artist": "627b61735bef0dc353f3d39a",
            "album_image": "album.jpg", 
        } 
        const albumData = await album.create(newAlbum)
        expect(albumData.title).toEqual("test")
        expect(album.artist).toEqual(mongoose.Types.ObjectId("627b61735bef0dc353f3d39a"))
        expect(albumData.album_image).toEqual("album.jpg")
    })

    // delete
    it('album delete testing', async ()=> {
        const status = await album.deleteMany()
        expect(status.ok)
    })
})