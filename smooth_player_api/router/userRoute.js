// Importing installed packages.....
const express = require("express");
const router = new express.Router();
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const validator = require("validator");
const fs = require("fs");

// Importing self made js files....
const user = require("../model/userModel")
const auth = require("../authentication/auth.js");
const profileUpload = require("../setting/profileSetting.js");


// User routes.....
router.post("/user/register", profileUpload.single("profile"), (req, res) => {
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }

    const username = req.body.username;
    const password = req.body.password;
    const email = req.body.email;
    const profile_name = req.body.profile_name;
    const profile_picture = req.file.filename
    const gender = req.body.gender;
    const birth_date = req.body.birth_date;
    const biography = req.body.biography;


    user.findOne({username : username}).then(function(userData) {
        if(userData!=null) {
            res.status(400).send({resM: "User already exists. try another username."});
            return;
        }
        user.findOne({email: email}).then(function(userData){
            if(userData!=null) {
                res.status(400).send({resM: "This email is already used, try another."});
                return;
            }        
            
           bcryptjs.hash(password, 10, async function(e, hashed_value) {
               const newUser = await user.create({
                   username: username,
                   password: hashed_value,
                   email: email,
                   profile_name: profile_name,
                   profile_picture: profile_picture,
                   gender: gender,
                   birth_date: birth_date,
                   biography: biography
               });

               res.status(201).send({resM: "Your account has been created."});
           });
        });
    })
});

router.post("/user/login", (req, res)=> {
    const username_email = req.body.username_email;
    const password = req.body.password;

    user.findOne({username: username_email}).then((userData)=> {
        if(userData==null) {
            if(!validator.isEmail(username_email)) {
                return res.status(400).send({resM: "User with that username does not exist or provide a valid email address."});
            }
            user.findOne({email: username_email}).then((userData1)=> {
                if(userData1==null) {
                    return res.status(400).send({resM: "User with that email address does not exist."});
                }

                bcryptjs.compare(password, userData1.password, function(e, result){
                    if(!result) {
                        res.status(400).send({resM: "Incorrect password, try again."});
                    }
                    else {  

                        const token = jwt.sign({userId: userData1._id}, "loginKey");
                        if(userData1.admin) {
                            res.status(202).send({token: token, resM: "Login success as admin.", userData: userData1});  
                        }
                        else {
                            res.status(202).send({token: token, resM: "Login success.", userData: userData1});  
                        }
                    }          
                }); 
            });
        }
        else {            
            bcryptjs.compare(password, userData.password, function(e, result){
                if(!result) {
                    res.status(400).send({resM: "Incorrect password, try again."});
                }
                else {  

                    const token = jwt.sign({userId: userData._id}, "loginKey");
                    if(userData.admin) {
                        res.status(202).send({token: token, resM: "Login success as admin.", userData: userData});  
                    }
                    else {
                        res.status(202).send({token: token, resM: "Login success.", userData: userData});  
                    }
                }          
            });
        }
    });
});

module.exports = router;