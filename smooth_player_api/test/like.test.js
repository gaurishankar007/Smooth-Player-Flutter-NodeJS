const like = require("../model/likeModel");
const mongoose = require("mongoose");

const url = "mongodb://localhost:27017/smooth_player_test";

beforeAll(async () => {
  mongoose.connect(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
});

afterAll(async () => {
  await mongoose.connection.close();
});

describe("like schema test", () => {
  // insert
  it("like insert", () => {
    const newlike = {
      user: "628b2ef4c986e83c7429dea4",
      song: "628b2ef4c986e83c7429dea1",
      album: "628b2ef4c986e83c7429dea2",
      featuredPlaylist: "628b2ef4c986e83c7429dea3",
    };

    return like.create(newlike).then((playlistData) => {
      expect(playlistData.user).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
      );
      expect(playlistData.song).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea1")
      );
      expect(playlistData.album).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea2")
      );
      expect(playlistData.featuredPlaylist).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea3")
      );
    });
  });

  //delete
  it("like delete", async () => {
    const status = await like.deleteMany();
    expect(status.ok);
  });
});
