const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const user = require("../model/userModel");
const album = require("../model/albumModel");
const recentlyPlayed = require("../model/RecentlyPlayedModel");
const playlist = require("../model/playlistModel");
const like = require("../model/likeModel");
const follow = require("../model/followModel");

router.get("/view/library", auth.verifyUser, async (req, res) => {
  const albumIds = [],
    artistIds = [],
    genres = [];

  const userData = await user.findOne({ _id: req.userInfo._id });

  const playlists = await playlist.findOne({
    user: req.userInfo._id,
  });

  const likedSongs = await like.findOne({
    user: req.userInfo._id,
    album: null,
    featuredPlaylist: null,
  });

  const follows = await follow.findOne({
    user: req.userInfo._id,
  });

  const likedAlbums = await like.findOne({
    user: req.userInfo._id,
    song: null,
    featuredPlaylist: null,
  });

  const likedFeaturedPlaylists = await like.findOne({
    user: req.userInfo._id,
    song: null,
    album: null,
  });

  const checkPlaylists = playlists !== null ? true : false;
  const checkFollows = follows !== null ? true : false;
  const checkLikedSongs = likedSongs !== null ? true : false;
  const checkLikedAlbums = likedAlbums !== null ? true : false;
  const checkLikedFeaturedPlaylists =
    likedFeaturedPlaylists !== null ? true : false;

  const recentlyPlayedSongs1 = await recentlyPlayed
    .find({ user: req.userInfo._id })
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(30);
  const recentlyPlayedSongs2 = await recentlyPlayed.populate(
    recentlyPlayedSongs1,
    {
      path: "song.album",
      select: "title artist album_image",
    }
  );
  const recentlyPlayedSongs = await recentlyPlayed.populate(
    recentlyPlayedSongs2,
    {
      path: "song.album.artist",
      select: "profile_name profile_picture biography follower verified",
    }
  );

  for (let i = 0; i < recentlyPlayedSongs.length; i++) {
    // recent albums
    if (albumIds.includes(recentlyPlayedSongs[i].song.album._id) === false) {
      albumIds.push(recentlyPlayedSongs[i].song.album._id);
    }

    // recent artist
    if (
      artistIds.includes(recentlyPlayedSongs[i].song.album.artist._id) === false
    ) {
      artistIds.push(recentlyPlayedSongs[i].song.album.artist._id);
    }

    // recent genres
    if (genres.includes(recentlyPlayedSongs[i].song.genre) === false && genres.length<=2) {
      genres.push(recentlyPlayedSongs[i].song.genre);
    }
  }

  const albums = await album
    .find({ _id: albumIds })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    )
    .limit(3);
    
  const artists = await user.find({ _id: artistIds }).limit(3);

  const userPlaylists = await playlist
    .find({ user: req.userInfo._id })
    .sort({ createdAt: -1 })
    .limit(3);

  res.send({
    profilePicture: userData.profile_picture,
    checkPlaylists: checkPlaylists,
    checkFollows: checkFollows,
    checkLikedSongs: checkLikedSongs,
    checkLikedAlbums: checkLikedAlbums,
    checkLikedFeaturedPlaylists: checkLikedFeaturedPlaylists,
    albums: albums,
    artists: artists,
    genres: genres,
    userPlaylists: userPlaylists,
  });
});

module.exports = router;
