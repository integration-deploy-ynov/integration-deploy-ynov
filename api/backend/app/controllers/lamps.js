const { Lamp } = require('../models');
const logger = require('../../logger');

/**
 * Récupérer toutes les difficultés.
 */
exports.readAll = async (req, res) => {
  try {
    const lamps = await Lamp.findAll();
    res.status(200).json(lamps);
  } catch (error) {
    logger.error({
      message: error.message,
      route: req.originalUrl,
      method: req.method,
      ip: req.ip,
      stack: error.stack
    });
    res.status(500).json({ error: error.message });
  }
};

/**
 * Mettre à jour une difficulté existante.
 */
// Mettre à jour une lampe
exports.update = async (req, res) => {
  const { id } = req.params;

  try {
    // Récupérer la lampe par son ID
    const lamp = await Lamp.findByPk(id);

    if (!lamp) {
      logger.error({
        message: 'Lampe non trouvée',
        route: req.originalUrl,
        method: req.method,
        ip: req.ip,
      });
      return res.status(404).json({ error: 'Lampe non trouvée' });
    }

    // Inverser l'état de la lampe (true -> false, false -> true)
    lamp.state = !lamp.state;
    await lamp.save();

    res.status(200).json({ message: 'Lampe mise à jour avec succès', lamp });
  } catch (error) {
    logger.error({
      message: error.message,
      route: req.originalUrl,
      method: req.method,
      ip: req.ip,
      stack: error.stack
    });
    res.status(500).json({ error: error.message });
  }
};