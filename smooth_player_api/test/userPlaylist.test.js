const playlist = require("../model/playlistModel");
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

describe("playlist schema test", () => {
  // insert
  it("playlist insert", async () => {
    const newPlaylist = {
      user: "628b2ef4c986e83c7429dea4",
      title: "Rock on",
    };

    const playlistData = await playlist.create(newPlaylist);
    expect(playlistData.user).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
    );
    expect(playlistData.title).toEqual("Rock on");
  });

  //delete
  it("playlist delete", async () => {
    const status = await playlist.deleteMany();
    expect(status.ok);
  });
});
