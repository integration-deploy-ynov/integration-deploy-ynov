#!/bin/bash

# Script de release pour Smart Lighting Project
# Gère les versions du backend et de l'application mobile de manière synchrone

set -e

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
  echo -e "${GREEN}==== $1 ====${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ ERREUR: $1${NC}"
  exit 1
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

# Vérifications préliminaires
print_step "Vérifications préliminaires"

# Vérifier Git
if ! command -v git &> /dev/null; then
  print_error "Git n'est pas installé"
fi

# Vérifier Node.js
if ! command -v node &> /dev/null; then
  print_error "Node.js n'est pas installé"
fi

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
  print_error "Flutter n'est pas installé"
fi

# Vérifier qu'on est dans un repo Git
if [ ! -d ".git" ]; then
  print_error "Ce script doit être exécuté à la racine du projet Git"
fi

# Vérifier la branche actuelle
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
  print_warning "Vous n'êtes pas sur la branche principale (actuellement: $current_branch)"
  read -p "Continuer quand même ? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Vérifier les changements non commités
if [ -n "$(git status --porcelain)" ]; then
  print_warning "Il y a des changements non commités"
  git status
  read -p "Continuer quand même ? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Récupérer la version actuelle
current_version=$(grep '"version"' package.json | cut -d'"' -f4)
print_info "Version actuelle: $current_version"

# Demander le type de release
echo
echo "Types de release disponibles:"
echo "1) patch (1.0.0 → 1.0.1) - Corrections de bugs"
echo "2) minor (1.0.0 → 1.1.0) - Nouvelles fonctionnalités"
echo "3) major (1.0.0 → 2.0.0) - Changements majeurs"
echo "4) custom - Spécifier une version"
echo

read -p "Choisir le type de release (1-4): " release_type

case $release_type in
  1)
    npm run version:patch
    ;;
  2)
    npm run version:minor
    ;;
  3)
    npm run version:major
    ;;
  4)
    read -p "Nouvelle version (ex: 1.2.3): " new_version
    if [ -z "$new_version" ]; then
      print_error "Version invalide"
    fi
    # Mettre à jour la version manuellement
    sed -i.bak "s/\"version\": \".*\"/\"version\": \"$new_version\"/" package.json
    rm package.json.bak 2>/dev/null || true
    ;;
  *)
    print_error "Choix invalide"
    ;;
esac

# Récupérer la nouvelle version
new_version=$(grep '"version"' package.json | cut -d'"' -f4)
print_success "Nouvelle version: $new_version"

print_step "Mise à jour des versions des sous-projets"

# Mettre à jour la version du backend
print_info "Mise à jour backend/package.json"
cd backend
sed -i.bak "s/\"version\": \".*\"/\"version\": \"$new_version\"/" package.json
rm package.json.bak 2>/dev/null || true
cd ..

# Mettre à jour la version de l'application mobile
print_info "Mise à jour mobile/pubspec.yaml"
cd mobile
current_build=$(grep "version:" pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)
new_build=$((current_build + 1))
sed -i.bak "s/^version: .*$/version: $new_version+$new_build/" pubspec.yaml
rm pubspec.yaml.bak 2>/dev/null || true
flutter pub get > /dev/null 2>&1
cd ..

print_step "Génération du changelog automatique"

# Générer le changelog depuis le dernier tag
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -n "$last_tag" ]; then
  print_info "Génération des changements depuis $last_tag"
  {
    echo "## [$new_version] - $(date +%Y-%m-%d)"
    echo
    echo "### Changements"
    git log --pretty=format:'- %s (%h)' "$last_tag"..HEAD | grep -E '^- (feat|fix|docs|style|refactor|perf|test|build|ci|chore)' | head -20
    echo
    echo
  } > CHANGELOG_NEW.md
  
  # Insérer le nouveau changelog après la ligne "## [Non publié]"
  sed -i.bak '/## \[Non publié\]/r CHANGELOG_NEW.md' CHANGELOG.md
  rm CHANGELOG.md.bak CHANGELOG_NEW.md
else
  print_info "Aucun tag précédent trouvé, pas de génération automatique"
fi

print_step "Tests et vérifications"

# Tests backend
print_info "Tests backend..."
cd backend
npm install > /dev/null 2>&1
npm test || print_warning "Certains tests backend ont échoué"
cd ..

# Tests mobile
print_info "Tests mobile..."
cd mobile
flutter test || print_warning "Certains tests mobile ont échoué"
cd ..

print_step "Finalisation de la release"

# Commit des changements
git add package.json backend/package.json mobile/pubspec.yaml mobile/pubspec.lock CHANGELOG.md
git commit -m "chore: bump version to $new_version

- Backend: $new_version
- Mobile: $new_version+$new_build
- Update CHANGELOG.md"

# Créer le tag
print_info "Création du tag v$new_version"
git tag -a "v$new_version" -m "Release version $new_version

🚀 Smart Lighting v$new_version

This release includes:
- Backend API version $new_version
- Mobile app version $new_version+$new_build

See CHANGELOG.md for detailed changes."

# Push vers le dépôt distant
print_info "Push vers le dépôt distant..."
git push origin HEAD
git push origin "v$new_version"

print_step "Release terminée avec succès! 🎉"

echo
print_success "Version $new_version créée et poussée"
print_info "Tag Git: v$new_version"
print_info "Backend: $new_version"
print_info "Mobile: $new_version+$new_build"
echo
print_info "Actions suivantes recommandées:"
echo "  • Vérifier les pipelines CI/CD"
echo "  • Créer une GitHub Release si nécessaire"
echo "  • Mettre à jour la documentation si requis"
echo "  • Déployer en production"
echo

print_info "Commandes utiles:"
echo "  • Voir les tags: git tag -l"
echo "  • Voir les changements: git log --oneline v$current_version..v$new_version"
echo "  • Annuler le tag: git tag -d v$new_version && git push origin :refs/tags/v$new_version" 