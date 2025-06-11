# 🏷️ Système de Versioning - Smart Lighting

Ce document décrit le système de versioning mis en place pour le projet Smart Lighting.

## 📋 Convention de Versioning

Le projet utilise [Semantic Versioning (SemVer)](https://semver.org/) avec le format **vX.Y.Z** :

- **X** (Major) : Changements incompatibles avec les versions précédentes
- **Y** (Minor) : Nouvelles fonctionnalités compatibles avec les versions précédentes  
- **Z** (Patch) : Corrections de bugs compatibles

### Exemples
- `v1.0.0` → `v1.0.1` : Correction de bug
- `v1.0.1` → `v1.1.0` : Nouvelle fonctionnalité
- `v1.1.0` → `v2.0.0` : Changement majeur (breaking change)

## 🚀 Script de Release

### Utilisation Basique

```bash
# Release automatique (menu interactif)
./release.sh

# Release directe par type
./release.sh patch   # v1.0.0 → v1.0.1
./release.sh minor   # v1.0.0 → v1.1.0  
./release.sh major   # v1.0.0 → v2.0.0
```

### Fonctionnalités du Script

Le script `release.sh` effectue automatiquement :

1. ✅ **Vérification Git** : S'assure que le dépôt est propre
2. 🧪 **Tests** : Exécute la suite de tests (backend + mobile)
3. 📝 **Version** : Met à jour le numéro de version dans `package.json`
4. 📋 **CHANGELOG** : Met à jour automatiquement le `CHANGELOG.md`
5. 🏷️ **Tag Git** : Crée un tag git avec la nouvelle version
6. 🚀 **Déploiement** : Lance le déploiement via Ansible (si configuré)

### Options Avancées

```bash
# Version personnalisée
./release.sh custom
# Puis entrer : 2.1.0-beta.1

# Release sans déploiement (modifier le script temporairement)
# Commenter la ligne `deploy_application`
```

## 📋 CHANGELOG Automatisé

Le fichier `CHANGELOG.md` suit la convention [Keep a Changelog](https://keepachangelog.com/) :

### Structure
- **[Unreleased]** : Changements en cours
- **[Version] - Date** : Changements publiés

### Catégories
- **Added** : Nouvelles fonctionnalités
- **Changed** : Modifications de fonctionnalités existantes
- **Deprecated** : Fonctionnalités obsolètes
- **Removed** : Fonctionnalités supprimées
- **Fixed** : Corrections de bugs
- **Security** : Correctifs de sécurité

## 🏷️ Tags Git

### Convention des Tags
- Format : `vX.Y.Z` (ex: `v1.2.3`)
- Tags annotés avec description
- Chaque tag contient le résumé du CHANGELOG

### Commandes Git Utiles

```bash
# Lister tous les tags
git tag -l

# Voir les détails d'un tag
git show v1.0.0

# Pousser tous les tags
git push origin --tags

# Supprimer un tag local
git tag -d v1.0.0

# Supprimer un tag distant
git push origin :refs/tags/v1.0.0
```

## 📁 Fichiers de Version

### `VERSION`
Fichier simple contenant uniquement le numéro de version actuel.

### `api/backend/package.json`
Fichier principal pour la version du backend Node.js.

### `CHANGELOG.md`
Historique complet des changements avec dates et descriptions.

## 🔄 Processus de Release

### 1. Développement
```bash
# Travailler sur une branche feature
git checkout -b feature/nouvelle-fonctionnalite
# ... développer ...
git commit -m "feat: ajouter contrôle de luminosité"
```

### 2. Préparation Release
```bash
# Merger vers main
git checkout main
git merge feature/nouvelle-fonctionnalite

# Vérifier que tout est propre
git status
```

### 3. Release
```bash
# Lancer le script de release
./release.sh minor

# Ou via le menu interactif
./release.sh
```

### 4. Publication
```bash
# Pousser vers le dépôt distant
git push origin main
git push origin --tags
```

## 🛠️ Configuration Avancée

### Variables du Script
Modifiables dans `release.sh` :

```bash
PROJECT_NAME="Smart Lighting System"
BACKEND_DIR="api/backend"
MOBILE_DIR="api/mobile"
VERSION_FILE="$BACKEND_DIR/package.json"
CHANGELOG_FILE="CHANGELOG.md"
```

### Intégration CI/CD
Le système de versioning s'intègre avec :
- GitLab CI (`gitlab-ci.yml`)
- CircleCI (`.circleci/config.yml`)
- GitHub Actions (`.github/workflows/`)

### Hooks Git (Optionnel)
Créer `.git/hooks/pre-commit` pour vérifier les conventions :

```bash
#!/bin/bash
# Vérifier le format des commits
if ! grep -qE "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+" "$1"; then
    echo "❌ Format de commit invalide. Utilisez : type(scope): description"
    exit 1
fi
```

## 📚 Références

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

---

## 🆘 Dépannage

### Problèmes Courants

**Script qui échoue sur les tests**
```bash
# Résoudre manuellement puis relancer
cd api/backend && npm test
./release.sh
```

**Tag déjà existant**
```bash
# Supprimer le tag et recommencer
git tag -d v1.0.1
./release.sh
```

**CHANGELOG corrompu**
```bash
# Restaurer depuis git et recommencer
git checkout HEAD -- CHANGELOG.md
./release.sh
``` 