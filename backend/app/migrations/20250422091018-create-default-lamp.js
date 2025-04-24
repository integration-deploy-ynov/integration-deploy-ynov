/* eslint-disable no-unused-vars */
'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Insertion d'une lampe de base
    await queryInterface.bulkInsert(
      'lamps',
      [
        {
          state: true, // Lampe allumée par défaut
          createdAt: new Date(),
          updatedAt: new Date()
        }
      ],
      {}
    );
  },

  down: async (queryInterface, Sequelize) => {
    // Annuler l'insertion de la lampe de base
    await queryInterface.bulkDelete('lamps', null, {});
  }
};
/* eslint-enable no-unused-vars */
