const jwt = require("jsonwebtoken");
const user = require("../model/userModel.js");

// Guard for normal user
module.exports.verifyUser = function(req, res, next) {
    try{
        const token = req.headers.authorization.split(" ")[1];
        const userData = jwt.verify(token, "loginKey");
        user.findOne({_id: userData.userId}).then((userDetail)=>{
            req.userInfo = userDetail;

            if (userDetail.admin === false) {
                next();
            }
            else {
                res.status(401).send({resM: "Access Denied."});
            }
        }).catch(function(e){
            res.status(400).send({resM: e});
        });
    }
    catch(e) {
        res.status(401).send({resM: "Invalid Token!"});
    }
} 

// Guard for admin user
module.exports.verifyAdmin = function(req, res, next) {
    try{
        const token = req.headers.authorization.split(" ")[1];
        const userData = jwt.verify(token, "loginKey");
        user.findOne({_id: userData.userId}).then((userDetail)=>{
            req.adminInfo = userDetail;

            if(userDetail.admin) {
                next();
            }
            else {
                res.status(401).send({resM: "Access Denied."});
            }
        }).catch(function(e){
            res.status(400).send({resM: e});
        });
    }
    catch(e) {
        res.status(401).send({resM: "Invalid Token!"});
    }
} 