const recentlyPlayed = require("../model/recentlyPlayedModel")
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

describe('recentlyPlayed schema test', ()=> {

    // insert
    it('recentlyPlayed insert testing', ()=> {
        const newRecentlyPlayed = {
            "user": "628b2ef4c986e83c7429dea4",
            "song": "628b299cf03f51231909eebe",
        } 

        return recentlyPlayed.create(newRecentlyPlayed).then((recentlyPlayedData)=>{
            expect(recentlyPlayedData.user).toEqual(mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4"))
            expect(recentlyPlayedData.song).toEqual(mongoose.Types.ObjectId("628b299cf03f51231909eebe"))
        })
    })

    // delete
    it('recentlyPlayed delete testing', async ()=> {
        const status = await recentlyPlayed.deleteMany()
        expect(status.ok)
    })
})