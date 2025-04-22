# Smart Lighting - Système de Contrôle d'Éclairage Intelligent

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Node.js](https://img.shields.io/badge/Node.js-18.x-green)

Un système complet de gestion d'éclairage intelligent composé d'une application mobile Flutter et d'un backend Node.js, configuré avec CI/CD pour un développement et déploiement continus.

## 📱 Présentation du Projet

Smart Lighting est une solution complète pour contrôler des lampes connectées. Le système se compose de :

- **Application Mobile** : Interface utilisateur intuitive pour contrôler les lampes à distance
- **API Backend** : Serveur REST pour gérer l'état des lampes dans une base de données

L'application permet aux utilisateurs de visualiser et de changer l'état (allumé/éteint) des lampes connectées avec une interface moderne et des animations fluides.

## 🏗️ Architecture

Le projet est organisé en deux parties principales :

### 📊 Backend (Node.js)

- Framework : **Express.js**
- Base de données : **SQLite** avec **Sequelize** ORM
- Structure MVC (Model-View-Controller)
- API RESTful pour la gestion des lampes

### 📱 Frontend (Flutter)

- Application mobile cross-platform (iOS/Android)
- Interface utilisateur moderne avec thème sombre
- Animations fluides lors des interactions
- Communication HTTP avec l'API backend

## 🚀 Fonctionnalités

- ✅ Affichage en temps réel de l'état des lampes
- ✅ Activation/désactivation des lampes avec animation
- ✅ Indication visuelle de l'état de connexion au serveur
- ✅ Interface utilisateur intuitive et responsive
- ✅ Base de données pour la persistance des données

## 🛠️ Installation et Configuration

### Prérequis

- [Node.js](https://nodejs.org/) (v14+ recommandé)
- [npm](https://www.npmjs.com/) ou [Yarn](https://yarnpkg.com/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Un éditeur de code (VS Code, Android Studio, etc.)

### Configuration du Backend

1. Accédez au dossier backend :
   ```bash
   cd backend
   ```

2. Installez les dépendances :
   ```bash
   npm install
   ```

3. Exécutez les migrations pour configurer la base de données :
   ```bash
   npx sequelize-cli db:migrate
   ```

4. Démarrez le serveur :
   ```bash
   npm start
   ```
   Le serveur démarre par défaut sur le port 5000.

### Configuration de l'Application Mobile

1. Accédez au dossier mobile :
   ```bash
   cd mobile
   ```

2. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```

3. Lancez l'application :
   ```bash
   flutter run
   ```

> **Note** : Par défaut, l'application mobile est configurée pour se connecter à `http://10.0.2.2:5000/api` qui est l'adresse du localhost de la machine hôte lorsqu'on utilise un émulateur Android. Pour utiliser un appareil physique ou modifier l'URL du backend, modifiez la variable `apiUrl` dans `lib/main.dart`.

## 📚 Documentation

Pour plus de détails sur chaque composant du système, consultez les README spécifiques :

- [Documentation Backend](./backend/README.md)
- [Documentation Frontend](./mobile/README.md)

## 🧪 Technologies Utilisées

### Backend
- Node.js
- Express.js
- Sequelize ORM
- SQLite
- Helmet (sécurité)
- Express Rate Limit

### Frontend
- Flutter
- Dart
- HTTP package
- Flutter Animate
- Google Fonts

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des issues ou des pull requests.

## 📄 Licence

Ce projet est sous licence MIT.