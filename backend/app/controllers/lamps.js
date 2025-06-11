const { Lamp } = require('../models');

/**
 * Récupérer toutes les difficultés.
 */
exports.readAll = async (req, res) => {
  try {
    const lamps = await Lamp.findAll();
    console.log(`Récupération de toutes les lampes: ${JSON.stringify(lamps)}`);
    
    res.status(200).json(lamps);
  } catch (error) {
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
    console.log(`Mise à jour de la lampe avec ID: ${id}`);
    
    const lamp = await Lamp.findByPk(id);

    if (!lamp) {
      return res.status(404).json({ error: 'Lampe non trouvée' });
    }

    // Inverser l'état de la lampe (true -> false, false -> true)
    lamp.state = !lamp.state;
    await lamp.save();

    res.status(200).json({ message: 'Lampe mise à jour avec succès', lamp });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
