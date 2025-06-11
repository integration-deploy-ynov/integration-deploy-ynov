# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Non publié]

### Ajouts
- Système de versioning avec tags Git
- CHANGELOG.md automatisé
- Script release.sh global

## [1.0.0] - 2024-12-19

### Ajouts
- Application mobile Flutter pour contrôler les lampes connectées
- Backend Node.js avec API REST
- Base de données SQLite avec Sequelize ORM
- Interface utilisateur moderne avec thème sombre
- Animations fluides lors des interactions
- Système de CI/CD avec GitHub Actions et CircleCI
- Tests automatisés pour le backend et le mobile
- Documentation complète du projet
- Stratégie Git avec workflow GitFlow

### Fonctionnalités
- Affichage en temps réel de l'état des lampes
- Activation/désactivation des lampes avec animation
- Indication visuelle de l'état de connexion au serveur
- Interface utilisateur intuitive et responsive
- Persistance des données en base

### Technique
- Framework Express.js pour le backend
- Application Flutter cross-platform (iOS/Android)
- Base de données SQLite avec Sequelize
- API RESTful pour la gestion des lampes
- Sécurité avec Helmet et Rate Limiting
- Tests avec Jest et Flutter Test
- Linting avec ESLint et Prettier

### Documentation
- README.md principal avec architecture complète
- Documentation backend détaillée
- Documentation mobile détaillée
- Stratégie Git avec conventions de commit
- Guide de contribution et workflows

---

## Guide de mise à jour du CHANGELOG

### Types de changements
- `Ajouts` pour les nouvelles fonctionnalités
- `Modifications` pour les changements aux fonctionnalités existantes
- `Déprécié` pour les fonctionnalités qui seront supprimées
- `Supprimé` pour les fonctionnalités supprimées
- `Corrigé` pour les corrections de bugs
- `Sécurité` en cas de vulnérabilités

### Format des versions
- MAJOR.MINOR.PATCH (ex: 1.0.0)
- MAJOR: changements incompatibles
- MINOR: nouvelles fonctionnalités compatibles
- PATCH: corrections de bugs compatibles

### Maintien automatique
Le CHANGELOG peut être mis à jour automatiquement avec :
```bash
npm run changelog  # Génère les changements depuis le dernier tag
``` 