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

## 🔄 Gestion des Versions et Releases

### Système de Versioning

Le projet utilise [Semantic Versioning](https://semver.org/) avec le format `MAJOR.MINOR.PATCH`:

- **MAJOR** : Changements incompatibles avec les versions précédentes
- **MINOR** : Nouvelles fonctionnalités compatibles
- **PATCH** : Corrections de bugs compatibles

### Script de Release

Un script automatisé `release.sh` permet de gérer facilement les releases :

```bash
# Lancer une nouvelle release
./release.sh

# Ou utiliser npm
npm run release
```

Le script effectue automatiquement :
- ✅ Vérifications préliminaires (Git, Node.js, Flutter)
- ✅ Mise à jour des versions (backend + mobile)
- ✅ Génération automatique du CHANGELOG
- ✅ Exécution des tests
- ✅ Création des commits et tags Git
- ✅ Push vers le dépôt distant

### Commandes Utiles

```bash
# Scripts de versioning
npm run version:patch    # 1.0.0 → 1.0.1
npm run version:minor    # 1.0.0 → 1.1.0
npm run version:major    # 1.0.0 → 2.0.0

# Scripts des sous-projets
npm run backend:start    # Démarrer le backend
npm run backend:test     # Tests backend
npm run mobile:run       # Lancer l'app mobile
npm run mobile:test      # Tests mobile

# Génération de changelog
npm run changelog        # Générer les changements depuis le dernier tag
```

### Tags Git

Les releases sont automatiquement taggées avec le format `vX.Y.Z` :

```bash
# Voir toutes les versions
git tag -l

# Voir les détails d'une version
git show v1.0.0

# Voir les changements entre versions
git log --oneline v1.0.0..v1.1.0
```

## 📚 Documentation

Pour plus de détails sur chaque composant du système, consultez les README spécifiques :

- [Documentation Backend](./backend/README.md)
- [Documentation Frontend](./mobile/README.md)
- [Changelog](./CHANGELOG.md) - Historique des versions
- [Stratégie Git](./GIT_STRATEGY.md) - Workflow de développement

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

Pour contribuer :
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commiter les changements (`git commit -m 'feat: add amazing feature'`)
4. Pousser la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

Consultez [GIT_STRATEGY.md](./GIT_STRATEGY.md) pour plus de détails sur les conventions.

## 📄 Licence

Ce projet est sous licence MIT.