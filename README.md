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

## 🏷️ Versioning et Releases

Ce projet utilise [Semantic Versioning](https://semver.org/) avec des tags Git automatisés et un CHANGELOG maintenu automatiquement.

### 🚀 Créer une Release

```bash
# Release automatique (menu interactif)
./release.sh

# Release directe par type
./release.sh patch   # v1.0.0 → v1.0.1 (corrections)
./release.sh minor   # v1.0.0 → v1.1.0 (nouvelles fonctionnalités)
./release.sh major   # v1.0.0 → v2.0.0 (breaking changes)
```

### 📝 Commits Conventionnels

Pour faciliter les commits, utilisez le script helper :

```bash
# Mode interactif
./commit.sh

# Mode direct
./commit.sh feat api "ajouter endpoint de contrôle luminosité"
./commit.sh fix mobile "corriger crash au démarrage"
```

### 📋 Suivi des Versions

- **VERSION** : Fichier contenant la version actuelle
- **CHANGELOG.md** : Historique automatique des changements
- **Tags Git** : Tags annotés pour chaque version (`v1.0.0`, `v1.1.0`, etc.)

### 🔄 Processus de Release Automatisé

Le script `release.sh` effectue automatiquement :

1. ✅ Vérification de l'état Git
2. 🧪 Exécution des tests
3. 📝 Mise à jour des versions
4. 📋 Mise à jour du CHANGELOG
5. 🏷️ Création du tag Git
6. 🚀 Déploiement via Ansible

Pour plus de détails, consultez [VERSIONING.md](./VERSIONING.md).

## 📚 Documentation

Pour plus de détails sur chaque composant du système, consultez les README spécifiques :

- [Documentation Backend](./backend/README.md)
- [Documentation Frontend](./mobile/README.md)
- [Système de Versioning](./VERSIONING.md)
- [Stratégie Git](./GIT_STRATEGY.md)

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

### DevOps & Infrastructure
- **CI/CD** : GitLab CI, CircleCI, GitHub Actions
- **Infrastructure** : Terraform (IaC)
- **Déploiement** : Ansible
- **Containerisation** : Docker
- **Monitoring** : Promtail, Logging avec Winston

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des issues ou des pull requests.

### Workflow de Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Utiliser les commits conventionnels (`./commit.sh feat "votre feature"`)
4. Pousser vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.