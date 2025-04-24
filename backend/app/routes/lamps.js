const express = require('express');
const router = express();
const lampsCtrl = require('../controllers/lamps.js');

/**
 * Routes pour gérer les defis.
 */
router.get('/', lampsCtrl.readAll);
router.put('/:id', lampsCtrl.update);

module.exports = router;
