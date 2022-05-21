const express = require("express");
const app = express();
const cors = require("cors");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.static(__dirname + "/upload"));

require("./database/connectDB");

const userRoute = require("./router/userRoute");
app.use(userRoute);

const albumRoute = require("./router/albumRoute");
app.use(albumRoute);

const songRoute = require("./router/songRoute");
app.use(songRoute);

const featuredPlaylistRoute = require("./router/featuredPlaylistRoute");
app.use(featuredPlaylistRoute);

const featuredSongRoute = require("./router/featuredSongRoute");
app.use(featuredSongRoute);

const RecentlyPlayed = require("./router/RecentlyPlayedRoute");
app.use(RecentlyPlayed);

app.listen(8080, () => {
  console.log("Server running on port: 8080...");
});
