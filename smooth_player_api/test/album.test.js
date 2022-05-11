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
    it('album insert testing', ()=> {
        const newAlbum = {
            "title": "test",
            "artist": "627b61735bef0dc353f3d39a",
            "album_image": "album.jpg",
            
        } 
        return album.create(newAlbum).then((userData)=>{
            expect(userData.title).toEqual("test")
            expect(userData.album_image).toEqual("album.jpg")
            
        })
    })

    delete
    it('album delete testing', async ()=> {
        const status = await album.deleteMany()
        expect(status.ok)
    })
})