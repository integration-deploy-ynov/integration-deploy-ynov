const express = require('express');
const app = express();
const rateLimit = require('express-rate-limit'); 
const slowDown = require('express-slow-down'); 
const helmet = require('helmet');
const router = require("./app/routes/index.js");
const db = require("./app/models/index.js");
const env = process.env.NODE_ENV || 'development';

db.sequelize
    .authenticate()
    .then(() => console.log("Database connected..."))
    .catch((err) => console.log(err));

app.use(express.json());

app.use("/api", router);

module.exports = app;