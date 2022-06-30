const report = require("../model/reportModel");
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

describe("report schema test", () => {
  // insert
  it("report", async () => {
    const newReport = {
      user: "628b2ef4c986e83c7429dea4",
      song: "628b2ef4c986e83c7429dea1",
      message: "Your song 'Mausam' has been reported for 'Vulgar content, CopyRight'",
      reportFor: ["Vulgar content", "CopyRight"]
    };

    const playlistData = await report.create(newReport);
    expect(playlistData.user).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
    );
    expect(playlistData.song).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea1")
    );
    expect(playlistData.message).toEqual(
      "Your song 'Mausam' has been reported for 'Vulgar content, CopyRight'"
    );
    expect(playlistData.reportFor).toEqual(
      ["Vulgar content", "CopyRight"]
    );
  });

  //delete
  it("report delete", async () => {
    const status = await report.deleteMany();
    expect(status.ok);
  });
});
