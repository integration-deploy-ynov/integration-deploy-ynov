#!/bin/bash

# 🚀 Script unifié de release pour projet déploiement Node.js
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Reset color

TOOL="$1"

# Affiche un menu si aucun argument
function show_menu() {
  echo "Quel outil veux-tu utiliser pour la release ?"
  echo "1) standard-version"
  echo "2) release-it"
  echo "3) semantic-release"
  read -p "Choix [1-3]: " choice
  case $choice in
    1) TOOL="standard-version" ;;
    2) TOOL="release-it" ;;
    3) TOOL="semantic-release" ;;
    *) echo -e "${RED}Choix invalide${NC}"; exit 1 ;;
  esac
}

if [ -z "$TOOL" ]; then
  show_menu
fi

echo -e "${GREEN}--- Lancement de la release avec : $TOOL ---${NC}"

# Aller dans le dossier backend de l'API
cd "$(dirname "$0")/api/backend"

# Installer les dépendances et lancer les tests
echo "📦 Installation des dépendances..."
npm install

echo "🧪 Exécution des tests..."
npm test

# Release selon l'outil choisi
case $TOOL in
  standard-version)
    echo "📦 Lancement de standard-version"
    npx standard-version
    git push --follow-tags origin main
    ;;
  release-it)
    echo "🚀 Lancement de release-it"
    npx release-it
    ;;
  semantic-release)
    echo "🤖 Lancement de semantic-release"
    npx semantic-release
    ;;
  *)
    echo -e "${RED}Erreur : outil non reconnu${NC}"
    exit 1
    ;;
esac

# Revenir à la racine
cd ../../

# Déploiement via Ansible
echo "🚀 Déploiement via Ansible..."
ansible-playbook -i infra/inventory.ini ansible/deploy_api.yml

echo -e "${GREEN}✅ Release & déploiement complétés avec succès via $TOOL${NC}"
