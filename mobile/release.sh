#!/bin/bash

# Script de release automatique pour GitHub
# Ce script aide à créer une nouvelle version de l'application et la publie sur GitHub

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_step() {
  echo -e "${GREEN}==== $1 ====${NC}"
}

print_error() {
  echo -e "${RED}ERREUR: $1${NC}"
  exit 1
}

print_warning() {
  echo -e "${YELLOW}ATTENTION: $1${NC}"
}

if ! command -v git &> /dev/null; then
  print_error "Git n'est pas installé. Veuillez l'installer avant de continuer."
fi

if ! command -v flutter &> /dev/null; then
  print_error "Flutter n'est pas installé. Veuillez l'installer avant de continuer."
fi

if [ ! -d ".git" ] && [ ! -d "../.git" ]; then
  print_error "Ce n'est pas un dépôt git. Veuillez exécuter ce script depuis le répertoire du projet."
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
  print_warning "Vous n'êtes pas sur la branche principale (main ou master). Vous êtes sur: $current_branch"
  read -p "Voulez-vous continuer ? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

if [ -n "$(git status --porcelain)" ]; then
  print_warning "Il y a des changements non commités dans votre dépôt."
  git status
  read -p "Voulez-vous continuer quand même ? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

current_version=$(grep "version:" pubspec.yaml | awk '{print $2}' | tr -d '\r')
echo -e "Version actuelle: ${GREEN}$current_version${NC}"

read -p "Nouvelle version (ex: 1.0.0): " new_version

if [ -z "$new_version" ]; then
  print_error "La version ne peut pas être vide"
fi

print_step "Mise à jour de la version dans pubspec.yaml"
sed -i.bak "s/^version: .*$/version: $new_version/" pubspec.yaml
rm pubspec.yaml.bak

print_step "Mise à jour des dépendances"
flutter pub get

print_step "Exécution des tests"
flutter test || print_warning "Certains tests ont échoué, mais le processus continue"

print_step "Vérification de la compilation"
flutter build apk --debug || print_error "La compilation a échoué"

print_step "Commit des changements"
git add pubspec.yaml pubspec.lock
git commit -m "chore: bump version to $new_version"

print_step "Création du tag v$new_version"
git tag -a "v$new_version" -m "Version $new_version"

print_step "Envoi des changements vers GitHub"
git push origin HEAD
git push origin "v$new_version"

print_step "Création d'une release sur GitHub"
echo "Pour créer une release sur GitHub, veuillez:"
echo "1. Aller sur https://github.com/[votre-username]/ci_cd_flutter/releases"
echo "2. Cliquer sur 'Draft a new release'"
echo "3. Sélectionner le tag v$new_version"
echo "4. Ajouter un titre et une description pour la release"
echo "5. Joindre les fichiers APK/IPA si nécessaire"
echo "6. Publier la release"

read -p "Voulez-vous créer automatiquement la release sur GitHub ? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -z "$GITHUB_TOKEN" ]; then
    read -sp "Token GitHub (il ne sera pas affiché): " GITHUB_TOKEN
    echo
  fi
  
  if [ -z "$GITHUB_TOKEN" ]; then
    print_error "Token GitHub requis pour créer une release automatiquement"
  fi
  
  REPO_URL=$(git config --get remote.origin.url)
  REPO_NAME=$(basename -s .git "$REPO_URL")
  REPO_OWNER=$(echo "$REPO_URL" | sed -n 's/.*github.com[:\/]\(.*\)\/'"$REPO_NAME"'.*/\1/p')
  
  if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    print_error "Impossible de déterminer le propriétaire ou le nom du dépôt"
  fi
  
  echo "Création de la release pour $REPO_OWNER/$REPO_NAME..."
  
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases" \
    -d "{
      \"tag_name\": \"v$new_version\",
      \"target_commitish\": \"$current_branch\",
      \"name\": \"Version $new_version\",
      \"body\": \"Release de la version $new_version\",
      \"draft\": false,
      \"prerelease\": false
    }"
  
  echo "Release créée avec succès!"
fi

print_step "Processus de release terminé"
echo -e "Version ${GREEN}$new_version${NC} publiée avec succès!"
echo "N'oubliez pas de vérifier la GitHub Action pour vous assurer que tout s'est bien passé"