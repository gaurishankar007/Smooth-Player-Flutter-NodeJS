const express = require("express");
const app = express();
const cors = require("cors");

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(express.static(__dirname+"/upload"))

require("./database/connectDB");

const userRoute = require("./router/userRoute");
app.use(userRoute);

const dotenv = require("dotenv");
dotenv.config();
const port = process.env.PORT || 5555;
app.listen(port, ()=> {console.log("Server running on port: "+port+"...")});