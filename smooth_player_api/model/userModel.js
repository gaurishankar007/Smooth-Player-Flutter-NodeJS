const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      trim: true,
    },
    password: {
      type: String,
      trim: true,
    },
    email: {
      type: String,
      trim: true,
    },
    profile_name: {
      type: String,
      trim: true,
    },
    profile_picture: {
      type: String,
    },
    gender: {
      type: String,
    },
    birth_date: {
      type: Date,
    },
    biography: {
      type: String,
      trim: true,
    },
    follower: {
      type: Number,
      default: 0,
    },
    verified: {
      type: Boolean,
      default: false,
    },
    admin: {
      type: Boolean,
      default: false,
    },
    profile_publication: {
      type: Boolean,
      default: false,
    },
    followed_artist_publication: {
      type: Boolean,
      default: false,
    },
    liked_song_publication: {
      type: Boolean,
      default: false,
    },
    liked_album_publication: {
      type: Boolean,
      default: false,
    },
    liked_featured_playlist_publication: {
      type: Boolean,
      default: false,
    },
    created_playlist_publication: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

const user = mongoose.model("user", userSchema);

module.exports = user;
