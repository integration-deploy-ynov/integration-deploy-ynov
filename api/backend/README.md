# Lamp Controller API

Cette API permet de contrôler l'état des lampes dans une base de données SQLite. Chaque lampe peut être allumée ou éteinte et son état est stocké dans la base de données. L'API offre des fonctionnalités pour récupérer toutes les lampes et mettre à jour leur état.

![Version](https://img.shields.io/badge/version-1.0.0-blue)

## Technologies utilisées

- **Node.js** - Environnement d'exécution JavaScript côté serveur.
- **Express.js** - Framework pour créer des API RESTful.
- **Sequelize** - ORM pour interagir avec la base de données SQLite.
- **SQLite** - Base de données légère pour stocker les données des lampes.
- **Nodemon** - Outil de développement qui redémarre l'application lorsque le code change.

## Structure du projet

```
backend/
├── app.js              # Configuration de l'application Express
├── index.js            # Point d'entrée de l'application
├── app/
│   ├── config/         # Configuration de la base de données
│   ├── controllers/    # Contrôleurs pour la gestion des requêtes
│   ├── migrations/     # Migrations Sequelize pour la base de données
│   ├── models/         # Modèles Sequelize pour les tables de la base de données
│   ├── routes/         # Définition des routes de l'API
│   └── scripts/        # Scripts utilitaires (initialisation de la BD, etc.)
└── database.sqlite     # Fichier de base de données SQLite
```

## Installation

### Prérequis

Assurez-vous d'avoir les outils suivants installés sur votre machine :

- [Node.js](https://nodejs.org/) (version 14 ou supérieure)
- [npm](https://www.npmjs.com/) (ou [Yarn](https://yarnpkg.com/) si vous préférez)

### Étapes d'installation

1. Installez les dépendances

   ```
   npm install
   ```

2. Exécutez les migrations pour configurer la base de données

   ```
   npx sequelize-cli db:migrate
   ```

3. Démarrez le serveur
   ```
   npm start
   ```

Le serveur démarre par défaut sur le port 5000. Vous pouvez modifier ce port en définissant la variable d'environnement PORT.

## Utilisation de l'API

### Récupérer toutes les lampes

**Méthode** : GET  
**Endpoint** : `/api/lamps`  
**Réponse** :

```json
[
  {
    "id": 1,
    "state": true
  },
  {
    "id": 2,
    "state": false
  }
]
```

### Mettre à jour l'état d'une lampe

**Méthode** : PUT  
**Endpoint** : `/api/lamps/:id`  
**Paramètres** : `id` - L'ID de la lampe à mettre à jour

L'état de la lampe sera inversé (si elle est allumée, elle devient éteinte, et inversement).

**Réponse** :

```json
{
  "message": "Lampe mise à jour avec succès",
  "lamp": {
    "id": 1,
    "state": false
  }
}
```

## Sécurité

L'API utilise plusieurs middlewares pour améliorer la sécurité :

- **helmet** : Protection contre les vulnérabilités web courantes
- **express-rate-limit** : Limitation du nombre de requêtes par utilisateur
- **express-slow-down** : Ralentissement progressif des requêtes suspectes

## Développement

Pour le développement, vous pouvez utiliser la commande suivante pour redémarrer automatiquement le serveur à chaque modification :

```
npm run dev
```

## Tests

Pour exécuter les tests :

```
npm test
```

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des pull requests.

## Licence

Ce projet est sous licence MIT.
