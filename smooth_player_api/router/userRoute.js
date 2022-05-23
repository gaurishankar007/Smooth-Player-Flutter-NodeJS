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
router.post("/admin/register", (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const confirm_password = req.body.confirm_password;
    const email = req.body.email;

    const usernameRegex = new RegExp('^[a-zA-Z0-9]+$');
    const passwordRegex = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,15}$');
    const emailRegex = new RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (username.trim()==="" || password.trim()==="" || email.trim()==="") {
        return res.status(400).send({resM: "Provide complete information."});  
    } else if (username.length<=2 || username.length>=16) {
        return res.status(400).send({resM: "Username most contain 3 to 15 characters."});  
    } else if (!usernameRegex.test(username)) {
        return res.status(400).send({resM: "Special characters and white spaces not allowed in username."});  
    } else if (!passwordRegex.test(password)) {
        return res.status(400).send({resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters."}); 
    } else if (password!==confirm_password) {
        return res.status(400).send({resM: "Confirm password did not match."}); 
    } else if (!emailRegex.test(email)) {
        return res.status(400).send({resM: "Invalid email address."}); 
    }

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
               const newAdmin = new user({
                   username: username,
                   password: hashed_value,
                   email: email,
                   admin: true,
               });

               newAdmin.save().then(()=>{
                   res.status(201).send({resM: "New admin account has been created."});
               });
           });
        });
    });
});

router.post("/user/register", profileUpload.single("profile"), (req, res) => {
    if(req.file==undefined) {
        return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
    }

    const username = req.body.username;
    const password = req.body.password;
    const confirm_password = req.body.confirm_password;
    const email = req.body.email;
    const profile_name = req.body.profile_name;
    const profile_picture = req.file.filename
    const gender = req.body.gender;
    const birth_date = req.body.birth_date;
    const biography = req.body.biography;

    const usernameRegex = new RegExp('^[a-zA-Z0-9]+$');
    const passwordRegex = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,15}$');
    const emailRegex = new RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (username.trim()==="" || password.trim()==="" || email.trim()==="" || profile_name.trim()==="" || gender.trim()==="" || birth_date.trim()==="") {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Provide complete information."});  
    } else if (username.length<=2 || username.length>=16) {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Username most contain 3 to 15 characters."});  
    } else if (!usernameRegex.test(username)) {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Special characters and white spaces not allowed in username."});  
    } else if (!passwordRegex.test(password)) {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters."}); 
    } else if (password!==confirm_password) {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Confirm password did not match."}); 
    } else if (!emailRegex.test(email)) {
        fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
        return res.status(400).send({resM: "Invalid email address."}); 
    }


    user.findOne({username : username}).then(function(userData) {
        if(userData!=null) {
            fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
            res.status(400).send({resM: "User already exists. try another username."});
            return;
        }
        user.findOne({email: email}).then(function(userData){
            if(userData!=null) {
                fs.unlinkSync(`../smooth_player_api/upload/image/user/${profile_picture}`);
                res.status(400).send({resM: "This email is already used, try another."});
                return;
            }        
            
           bcryptjs.hash(password, 10, async function(e, hashed_value) {
               const newUser = new user({
                   username: username,
                   password: hashed_value,
                   email: email,
                   profile_name: profile_name,
                   profile_picture: profile_picture,
                   gender: gender,
                   birth_date: birth_date,
                   biography: biography
               });

               newUser.save().then(()=>{
                   res.status(201).send({resM: "Your account has been created."});
               });
           });
        });
    });
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

router.get("/user/view", auth.verifyUser, (req, res)=>{
    user.findOne({_id: req.userInfo._id})
    .then((userData)=>{
        res.send(userData)
    });
});

router.put("/user/changeProfilePicture", auth.verifyUser, profileUpload.single("profile"), (req, res)=> { 
   if(req.file==undefined) {
       return res.status(400).send({resM: "Invalid image format, only supports png or jpeg image format."});
   }

   user.findOne({_id: req.userInfo._id}).then((userData)=> {
       fs.unlinkSync(`../smooth_player_api/upload/image/user/${userData.profile_picture}`); 
       user.updateOne({_id: req.userInfo._id}, {profile_picture: req.file.filename})
       .then(()=>{
           res.send({resM:"Profile Picture Updated"});
       })
   })
});

router.put("/user/changeUsername", auth.verifyUser, (req, res)=> {  
   const username = req.body.username;
   const usernameRegex = new RegExp('^[a-zA-Z0-9]+$');

   if(username.trim()==="") {        
      return res.status(400).send({resM: "Provide username."});  
   } else if (username.length<=2 || username.length>=16) {
      return res.status(400).send({resM: "Username most contain 3 to 15 characters."});  
   } else if (!usernameRegex.test(username)) {
      return res.status(400).send({resM: "Special characters and white spaces not allowed in username."});  
   }

   user.findOne({username: username}).then(function(userData) {
       if(userData!=null) {
           return res.status(400).send({resM: "This username is already used, try another."});
       }  
       user.updateOne({_id: req.userInfo._id}, {username: username})
       .then(()=>{
           res.send({resM: "Your username has been changed."});
       }) 
   })
});


router.put("/user/changeEmail", auth.verifyUser, (req, res)=> {  
   const email = req.body.email;
   const emailRegex = new RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

   if (email.trim()==="") {
       return res.status(400).send({resM: "Provide email address."}); 
   } else if (!emailRegex.test(email)) {
       return res.status(400).send({resM: "Invalid email address."}); 
    }

   user.findOne({email: email}).then(function(userData) {
       if(userData!=null) {
           return res.status(400).send({resM: "This email is already used, try another."});
       }  
       user.updateOne({_id: req.userInfo._id}, {email: email})
       .then(()=>{
           res.send({resM: "Your email has been changed."});
       }) 
   })
});

router.put("/user/changeProfileName", auth.verifyUser, (req, res)=> {  
   const profile_name = req.body.profile_name;

    if(profile_name.trim()===""){
        return res.status(400).send({resM:"Provide profile name."})
    }

   user.updateOne({_id: req.userInfo._id}, {profile_name: profile_name})
   .then(()=>{
       res.send({resM: "Your profile name has been changed."});
   }) 
});

router.put("/user/changePassword", auth.verifyUser, (req, res)=> {
   const currPassword = req.body.currPassword;
   const newPassword = req.body.newPassword;

   const passwordRegex = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,15}$');

   if (currPassword.trim()==="" || newPassword.trim()==="" ) {
       return res.status(400).send({resM: "Provide both current and new password."});  
   } else if(currPassword===newPassword){
       return res.status(400).send({resM:"Current Password and New Password are Same"})
   } else if (!passwordRegex.test(newPassword)) {
       return res.status(400).send({resM: "Provide at least one uppercase, lowercase, number, special character in password and it accepts only 5 to 15 characters."}); 
   }

   user.findOne({_id: req.userInfo._id}).then((userData)=> {
       bcryptjs.compare(currPassword, userData.password, function(e, result) {
           if(!result) {
               return res.status(400).send({resM: "Current Password did not match."});
           }
           bcryptjs.hash(newPassword, 10, (e, hashed_pass)=> {
               user.updateOne({_id: userData._id}, {password: hashed_pass})
               .then(()=> {
                   res.send({resM: "Your password has been changed."});
               });
           });
       });
   });
});

router.put("/user/changeGender", auth.verifyUser, (req, res)=> {  
   const gender = req.body.gender;

   if(gender.trim()==="") {
       return res.status(400).send({resM: "Gender not provided."});
   }

   user.updateOne({_id: req.userInfo._id}, {gender: gender}).then(()=>{
       res.send({resM: "Your gender has been changed."});
   }); 
});

router.put("/user/changeBirthDate", auth.verifyUser, (req, res)=> {  
   const birth_date = req.body.birth_date;

   if(birth_date.trim()==="") {
       return res.status(400).send({resM: "Birth date not provided."});
   }
    
   user.updateOne({_id: req.userInfo._id}, {birth_date: birth_date}).then(()=>{
       res.send({resM: "Your birth date has been changed."});
   }); 
});

router.put("/user/changeBiography", auth.verifyUser, (req, res)=> {  
   const biography = req.body.biography;

   if(biography.trim()==="") {
       return res.status(400).send({resM: "Biography not provided."});
   }

   user.updateOne({_id: req.userInfo._id}, {biography: biography}).then(()=>{
        res.send({resM: "Your biography has been changed."});
   });       
});

module.exports = router;