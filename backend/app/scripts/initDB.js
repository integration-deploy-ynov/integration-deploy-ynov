const db = require('../models');

(async () => {
  try {
    await db.sequelize.sync({ force: true }); // force: true => supprime et recrée les tables
    console.log("La base de données et les tables ont été créées !");
  } catch (error) {
    console.error("Erreur lors de la création :", error);
  } finally {
    await db.sequelize.close();
  }
})();