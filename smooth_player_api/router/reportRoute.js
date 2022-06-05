const express = require("express");
const router = new express.Router();
const mongoose = require("mongoose");
const auth = require("../authentication/auth");
const report = require("../model/reportModel");

router.post("/report/song", auth.verifyUser, (req, res) => {
  const reportFor = req.body.reportFor;
  if (reportFor === undefined) {
    return res.status(400).send({ resM: "Select at least one reason." });
  }

  const newReport = new report({
    user: req.userInfo._id,
    song: mongoose.Types.ObjectId(req.body.songId),
    reportFor: reportFor,
  });

  newReport.save().then(() => {
    res.status(201).send({ resM: "Your report has been submitted." });
  });
});

router.put("/report/solved", auth.verifyUser, (req, res) => {
  report
    .findOneAndUpdate({ _id: req.body.reportId }, { solved: true })
    .then(() => {
      res.status(201).send({ resM: "Report has been solved." });
    });
});

module.exports = router;
