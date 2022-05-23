const mongoose = require("mongoose");
const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const fs = require("fs");
const albumUpload = require("../setting/albumSetting");
const user = require("../model/userModel");
const album = require("../model/albumModel");



router.get("/load/home", async (req, res) => {
    
}); 

module.exports = router;