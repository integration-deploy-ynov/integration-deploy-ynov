const express = require('express');
const router = express();
const lampsCtrl = require('../controllers/lamps.js');

/**
 * Routes pour gérer les defis.
 */
router.post('/', lampsCtrl.start);
router.put('/', lampsCtrl.readAll);

module.exports = router;