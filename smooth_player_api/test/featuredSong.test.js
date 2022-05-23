const featuredSong = require("../model/featureSongModel")
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

describe('featuredSong schema test', ()=> {

    // insert
    it('featuredSong insert testing', ()=> {
        const newFeaturedSong = {
            "featuredPlaylist": "628b2d419edc02081d18d6a3",
            "song": "628b299cf03f51231909eebe",
        } 
        
        return featuredSong.create(newFeaturedSong).then((featuredSongData)=>{
            expect(featuredSongData.featuredPlaylist).toEqual(mongoose.Types.ObjectId("628b2d419edc02081d18d6a3"))
            expect(featuredSongData.song).toEqual(mongoose.Types.ObjectId("628b299cf03f51231909eebe"))
        })
    })

    // delete
    it('featuredSong delete testing', async ()=> {
        const status = await featuredSong.deleteMany()
        expect(status.ok)
    })
})