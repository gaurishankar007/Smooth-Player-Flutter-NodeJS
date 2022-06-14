const playlistSong = require("../model/playlistSongModel");
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

describe("playlistSong schema test", () => {
  // insert
  it("playlistSong insert", async () => {
    const newPlaylistSong = {
      playlist: "628b2ef4c986e83c7429dea4",
      song: "628b2ef4c986e83c7429dea4",
    };

    const playlistSongData = await playlistSong.create(newPlaylistSong);
    expect(playlistSongData.playlist).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
    );
    expect(playlistSongData.song).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
    );
  });

  //delete
  it("playlistSong delete", async () => {
    const status = await playlistSong.deleteMany();
    expect(status.ok);
  });
});
