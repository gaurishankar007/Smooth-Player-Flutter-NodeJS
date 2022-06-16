const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const bcryptjs = require("bcryptjs");
const user = require("../model/userModel");
const token = require("../model/tokenModel");
const sendEmail = require("../utils/sendEmail.js");

router.post("/generate/token", async (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  const passwordRegex = new RegExp(
    "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{5,15}$"
  );

  if (email.trim() === "" || password.trim() === "") {
    return res.status(400).send({ resM: "Provide both email and password." });
  } else if (!passwordRegex.test(password)) {
    return res.status(400).send({
      resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters.",
    });
  }

  const userData = await user.findOne({ email: email });
  if (userData === null) {
    return res
      .status(400)
      .send({ resM: "User with that email does not exist." });
  }

  const tokenData = await token.find({ user: userData._id });
  if (tokenData.length > 0) {
    token.deleteMany({ user: userData._id }).then();
  }

  const t1 = Math.floor(Math.random() * 9 + 1).toString();
  const t2 = Math.floor(Math.random() * 9).toString();
  const t3 = Math.floor(Math.random() * 9).toString();
  const t4 = Math.floor(Math.random() * 9).toString();
  const t5 = Math.floor(Math.random() * 9).toString();
  const t6 = Math.floor(Math.random() * 9).toString();
  const tokenNumber = parseInt(t1 + t2 + t3 + t4 + t5 + t6);

  const newToken = new token({
    user: userData._id,
    password: password,
    token: tokenNumber,
  });

  newToken.save().then(() => {
    sendEmail(
      email,
      "Password Reset Token",
      "Your password reset token is " + tokenNumber + "."
    );
    res.status(201).send({ resM: "Token generated.", userId: userData._id });
  });
});

router.put("/verify/token", (req, res) => {
  const tokenNumber = req.body.tokenNumber;
  const userId = req.body.userId;

  const numberReg = new RegExp("^[0-9]+$");
  if (!numberReg.test(tokenNumber)) {
    return res.status(400).send({ resM: "Invalid token number." });
  }

  token.findOne({ token: tokenNumber, user: userId }).then((tokenData) => {
    if (tokenData === null) {
      return res.status(400).send({ resM: "Invalid token number." });
    }

    const currentDate = new Date(Date.now());
    const currentDateTime = currentDate.getTime();
    const tokenDateTime = tokenData.createdAt.getTime();
    const tokenGeneratedTime = Math.floor(
      (currentDateTime - tokenDateTime) / 60000
    ); // In minute

    if (tokenGeneratedTime > 5) {
      return res.status(400).send({ resM: "Token number expired." });
    }

    bcryptjs.hash(tokenData.password, 10, function (e, hashed_value) {
      user
        .findOneAndUpdate({ _id: userId }, { password: hashed_value })
        .then(() => {
          token.deleteOne({ token: tokenNumber, user: userId }).then(() => {
            res.send({ resM: "Password reset. Now log in with new password." });
          });
        });
    });
  });
});

module.exports = router;
