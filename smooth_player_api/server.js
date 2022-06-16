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

const artist = require("./router/ArtistRoute");
app.use(artist);

const home = require("./router/homeRoute");
app.use(home);

const follow = require("./router/followRoute");
app.use(follow);

const like = require("./router/likeRoute");
app.use(like);

const report = require("./router/reportRoute");
app.use(report);

const playlist = require("./router/playlistRoute");
app.use(playlist);

const playlistSong = require("./router/playlistSongRoute");
app.use(playlistSong);

const library = require("./router/libraryRoute");
app.use(library);

const token = require("./router/tokenRoute");
app.use(token);

app.listen(8080, () => {
  console.log("Server running on port: 8080...");
});
