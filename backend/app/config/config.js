module.exports = {
    development: {
      dialect: 'sqlite',
      storage: './app/database.sqlite', // Spécifie le chemin relatif vers le fichier de ta base de données
      logging: false // Optionnel : éviter d'afficher les requêtes SQL dans la console
    },
    test: {
      dialect: 'sqlite',
      storage: './app/database.sqlite',
      logging: false
    },
    production: {
      dialect: 'sqlite',
      storage: './app/database.sqlite',
      logging: false
    }
  };
  