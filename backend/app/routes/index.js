const express = require('express')
const router = express();
const lampsRoutes = require('./lamps.js');

/**
 * Les différentes routes de l'application sont définies ici et reliées à leur fichier respectif.
 * 
 * @module routes
 */
router.use("/lamps", lampsRoutes);

module.exports = router;