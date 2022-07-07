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
            "artist": "62c6d1108acf866ad1d60d32",
            "album_image": "album.jpg", 
        } 
        const albumData = await album.create(newAlbum)
        expect(albumData.title).toEqual("test")
        expect(albumData.artist).toEqual(mongoose.Types.ObjectId("62c6d1108acf866ad1d60d32"))
        expect(albumData.album_image).toEqual("album.jpg")
    })

    // delete
    it('album delete testing', async ()=> {
        const status = await album.deleteMany()
        expect(status.ok)
    })
})