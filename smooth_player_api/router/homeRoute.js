const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const user = require("../model/userModel");
const album = require("../model/albumModel");
const recentlyPlayed = require("../model/RecentlyPlayedModel");
const featuredPlaylist = require("../model/featurePlaylistModel");
const follow = require("../model/followModel");

router.get("/load/home", auth.verifyUser, async (req, res) => {
  const albumIds = [],
    albumIdsCount = [],
    sortedAlbumIdsAndCount = [],
    sortedAlbumIds = [],
    artistIds = [],
    artistIdsCount = [],
    sortedArtistIdsAndCount = [],
    sortedArtistIds = [],
    genres = [],
    genresCount = [],
    sortedGenresAndCount = [],
    sortedGenres = [],
    prevAlbumIds = [],
    prevAlbumIdsCount = [],
    sortedPrevAlbumIdsAndCount = [],
    sortedPrevAlbumIds = [];

  // Getting users recently mostly played popularAlbums
  const recentlyPlayedSongs1 = await recentlyPlayed
    .find({ user: req.userInfo._id })
    .populate("song")
    .sort({ createdAt: -1 })
    .limit(100);
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
    // recently played albums
    if (albumIds.includes(recentlyPlayedSongs[i].song.album._id) === false) {
      albumIds.push(recentlyPlayedSongs[i].song.album._id);
      albumIdsCount.push(1);
    } else {
      const albumIndex = albumIds.indexOf(
        recentlyPlayedSongs[i].song.album._id
      );
      albumIdsCount[albumIndex] = albumIdsCount[albumIndex] + 1;
    }

    // favorite artist
    if (
      artistIds.includes(recentlyPlayedSongs[i].song.album.artist._id) === false
    ) {
      artistIds.push(recentlyPlayedSongs[i].song.album.artist._id);
      artistIdsCount.push(1);
    } else {
      const artistIndex = artistIds.indexOf(
        recentlyPlayedSongs[i].song.album.artist._id
      );
      artistIdsCount[artistIndex] = artistIdsCount[artistIndex] + 1;
    }

    // favorite genres
    if (genres.includes(recentlyPlayedSongs[i].song.genre) === false) {
      genres.push(recentlyPlayedSongs[i].song.genre);
      genresCount.push(1);
    } else {
      const genreIndex = genres.indexOf(recentlyPlayedSongs[i].song.genre);
      genresCount[genreIndex] = genresCount[genreIndex] + 1;
    }
  }
  for (let i = 0; i < albumIds.length; i++) {
    sortedAlbumIdsAndCount.push({ id: albumIds[i], count: albumIdsCount[i] });
  }
  sortedAlbumIdsAndCount.sort((a, b) => b.count - a.count); // Sorting according to the count
  for (let i = 0; i < sortedAlbumIdsAndCount.length; i++) {
    if (sortedAlbumIds.length <= 6) {
      sortedAlbumIds.push(sortedAlbumIdsAndCount[i].id.toString());
    }
  }
  const recentAlbums = await album
    .find({ _id: sortedAlbumIds })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    );

  // Getting users recent favorite artists
  for (let i = 0; i < artistIds.length; i++) {
    if (artistIds[i].toString() != req.userInfo._id.toString()) {
      sortedArtistIdsAndCount.push({
        id: artistIds[i],
        count: artistIdsCount[i],
      });
    }
  }
  sortedArtistIdsAndCount.sort((a, b) => b.count - a.count);
  for (let i = 0; i < sortedArtistIdsAndCount.length; i++) {
    if (sortedArtistIds.length <= 6) {
      sortedArtistIds.push(sortedArtistIdsAndCount[i].id.toString());
    }
  }
  const recentFavoriteArtists = await user.find({ _id: sortedArtistIds });

  // Getting users recent favorite song genres
  for (let i = 0; i < genres.length; i++) {
    sortedGenresAndCount.push({
      id: genres[i],
      count: genresCount[i],
    });
  }
  sortedGenresAndCount.sort((a, b) => b.count - a.count);
  for (let i = 0; i < sortedGenresAndCount.length; i++) {
    if (sortedGenres.length <= 6) {
      sortedGenres.push(sortedGenresAndCount[i].id.toString());
    }
  }

  // Getting users previously played albums
  const previouslyPlayedSongs1 = await recentlyPlayed
    .find({ user: req.userInfo._id, _id: { $nin: recentlyPlayedSongs1 } })
    .populate("song")
    .sort({ createdAt: -1 });
  const previouslyPlayedSongs2 = await recentlyPlayed.populate(
    previouslyPlayedSongs1,
    {
      path: "song.album",
      select: "title artist album_image",
    }
  );
  const previouslyPlayedSongs = await recentlyPlayed.populate(
    previouslyPlayedSongs2,
    {
      path: "song.album.artist",
      select: "profile_name profile_picture biography follower verified",
    }
  );
  for (let i = 0; i < previouslyPlayedSongs.length; i++) {
    if (
      prevAlbumIds.includes(previouslyPlayedSongs[i].song.album._id) === false
    ) {
      prevAlbumIds.push(previouslyPlayedSongs[i].song.album._id);
      prevAlbumIdsCount.push(1);
    } else {
      const albumIndex = prevAlbumIds.indexOf(
        previouslyPlayedSongs[i].song.album._id
      );
      prevAlbumIdsCount[albumIndex] = prevAlbumIdsCount[albumIndex] + 1;
    }
  }
  for (let i = 0; i < prevAlbumIds.length; i++) {
    if (sortedAlbumIds.includes(prevAlbumIds[i].toString()) === false) {
      sortedPrevAlbumIdsAndCount.push({
        id: prevAlbumIds[i],
        count: prevAlbumIdsCount[i],
      });
    }
  }
  sortedPrevAlbumIdsAndCount.sort((a, b) => b.count - a.count); // Sorting according to the count
  for (let i = 0; i < sortedPrevAlbumIdsAndCount.length; i++) {
    if (sortedAlbumIds.length <= 6) {
      sortedPrevAlbumIds.push(sortedPrevAlbumIdsAndCount[i].id);
    }
  }
  const jumpBackIn = await album
    .find({ _id: sortedPrevAlbumIds })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    );

  // Getting new releases from followed artists
  const followedArtist = [];
  const followings = await follow.find({ user: req.userInfo._id });
  for (let i = 0; i < followings.length; i++) {
    followedArtist.push(followings[i].artist);
  }
  const newReleases = await album
    .find({
      artist: followedArtist,
      createdAt: { $gte: new Date(Date.now() - 2592000000) },
    })
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    )
    .sort({ createdAt: -1 });

  // Getting popular music contents
  const popularFeaturedPlaylists = await featuredPlaylist
    .find()
    .sort({ like: -1 })
    .limit(10);
  const popularAlbums = await album
    .find()
    .populate(
      "artist",
      "profile_name profile_picture biography follower verified"
    )
    .sort({ like: -1 })
    .limit(10);
  const popularArtist = await user
    .find({ admin: false, verified: true })
    .sort({ follower: -1 })
    .limit(10);

  res.send({
    recentAlbums: recentAlbums,
    recentFavoriteArtists: recentFavoriteArtists,
    recentFavoriteGenres: sortedGenres,
    jumpBackIn: jumpBackIn,
    newReleases: newReleases,
    popularFeaturedPlaylists: popularFeaturedPlaylists,
    popularAlbums: popularAlbums,
    popularArtists: popularArtist,
  });
});

router.post("/get/featuredPlaylists", auth.verifyUser, async (req, res) => {
  const featuredPlaylistNum = req.body.featuredPlaylistNum;

  const featuredPlaylists = await featuredPlaylist
    .find()
    .sort({ createdAt: -1 })
    .limit(featuredPlaylistNum);

  res.send(featuredPlaylists);
});

module.exports = router;
