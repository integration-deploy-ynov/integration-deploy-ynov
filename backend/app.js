const express = require("express");
const rateLimit = require("express-rate-limit");
const slowDown = require("express-slow-down");
const helmet = require("helmet");
const router = require("./app/routes/index.js");
const db = require("./app/models/index.js");

const app = express();

const initApp = async () => {
  await db.sequelize.authenticate();
  console.log("Database connected...");

  app.use(express.json());
  app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 })); // Example rate limit
  app.use(
    slowDown({
      windowMs: 15 * 60 * 1000,
      delayAfter: 100,
      delayMs: () => 500,
    })
  );
  app.use(helmet());
  app.use("/api", router);

  return app;
};

module.exports = initApp;
