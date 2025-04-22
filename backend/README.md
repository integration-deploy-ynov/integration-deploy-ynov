# Lamp Controller API

Cette API permet de contrôler l'état des lampes dans une base de données SQLite. Chaque lampe peut être allumée ou éteinte et son état est stocké dans la base de données. L'API offre des fonctionnalités pour récupérer toutes les lampes et mettre à jour leur état.

## Technologies utilisées

- **Node.js** - Environnement d'exécution JavaScript côté serveur.
- **Express.js** - Framework pour créer des API RESTful.
- **Sequelize** - ORM pour interagir avec la base de données SQLite.
- **SQLite** - Base de données légère pour stocker les données des lampes.
- **Nodemon** - Outil de développement qui redémarre l'application lorsque le code change.

## Installation

### Prérequis

Assurez-vous d'avoir les outils suivants installés sur votre machine :
- [Node.js](https://nodejs.org/) (version 14 ou supérieure)
- [npm](https://www.npmjs.com/) (ou [Yarn](https://yarnpkg.com/) si vous préférez)

### Étapes d'installation

1. npm install
2. npx sequelize-cli db:migrate
3. npm start


### Utilisation de l'api

Utilisation de l'API
Récupérer toutes les lampes
Méthode : GET

Endpoint : /api/lamps

Réponse :

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

Mettre à jour l'état d'une lampe
Méthode : PUT

Endpoint : /api/lamps/:id

Paramètres :

id: L'ID de la lampe à mettre à jour.

L'état de la lampe sera inversé (si elle est true, elle devient false, et inversement).

Réponse :

{
  "message": "Lampe mise à jour avec succès",
  "lamp": {
    "id": 1,
    "state": false
  }
}