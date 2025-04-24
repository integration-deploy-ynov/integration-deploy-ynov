/* eslint-disable no-console */
require('dotenv').config();
const initApp = require('./app.js');
const port = process.env.PORT;

const startServer = async () => {
  const app = await initApp();
  app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
  });
};

startServer();
/* eslint-enable no-console */
