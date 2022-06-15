const token = require("../model/tokenModel");
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

describe("token schema test", () => {
  // insert
  it("token insert", async () => {
    const newToken = {
      user: "628b2ef4c986e83c7429dea4",
      password: "Jomba@55",
      token: 128904,
    };

    const tokenData = await token.create(newToken);
    expect(tokenData.user).toEqual(
      mongoose.Types.ObjectId("628b2ef4c986e83c7429dea4")
    );
    expect(tokenData.password).toEqual("Jomba@55");
    expect(tokenData.token).toEqual(128904);
  });

  //delete
  it("token delete", async () => {
    const status = await token.deleteMany();
    expect(status.ok);
  });
});
