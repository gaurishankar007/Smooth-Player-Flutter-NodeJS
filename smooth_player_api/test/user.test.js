const user = require("../model/userModel")
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

describe('user schema test', ()=> {

    // insert
    it('user insert testing', async ()=> {
        const newUser = {
            "username": "john08",
            "password": "John@23",
            "email": "john896@gmail.com",
            "profile_name": "John Don",
            "profile_picture": "profile.jpg",
            "gender": "Male",
            "birth_date": "1986-06-13",
            "biography": "I am John Don and I take control of the world.",
        } 
        const userData = await user.create(newUser)
        expect(userData.username).toEqual("john08")
        expect(userData.password).toEqual("John@23")
        expect(userData.email).toEqual("john896@gmail.com")
        expect(userData.profile_name).toEqual("John Don")
        expect(userData.profile_picture).toEqual("profile.jpg")
        expect(userData.gender).toEqual("Male")
        expect(Date(userData.birth_date)).toEqual(Date("1986-06-13T00:00:00.000Z"))
        expect(userData.biography).toEqual("I am John Don and I take control of the world.")
        expect(userData.verified).toEqual(false)
        expect(userData.admin).toEqual(false)
        expect(userData.verified).toEqual(false)
        expect(userData.profile_publication).toEqual(false)
        expect(userData.followed_artist_publication).toEqual(false)
        expect(userData.liked_song_publication).toEqual(false)
        expect(userData.liked_album_publication).toEqual(false)
        expect(userData.liked_featured_playlist_publication).toEqual(false)
        expect(userData.created_playlist_publication).toEqual(false)
    })

    // delete
    it('user delete testing', async ()=> {
        const status = await user.deleteMany()
        expect(status.ok)
    })
})