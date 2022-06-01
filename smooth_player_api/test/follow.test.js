const follow = require("../model/followModel");
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

describe("follow schema test", () => {
  // insert
  it("follow insert", () => {
    const newFollower = {
      user: "628b2ef4c986e83c7429dea4",
      artist: "628b2ef4c986e83c7429dea1",
    };

    return follow.create(newFollower).then((playlistData) => {
      expect(playlistData.user).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
      );
      expect(playlistData.artist).toEqual(
        mongoose.Types.ObjectId("628b2ef4c986e83c7429dea1")
      );
    });
  });

  //delete
  it("follower delete", async () => {
    const status = await follow.deleteMany();
    expect(status.ok);
  });
});
