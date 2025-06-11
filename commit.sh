#!/bin/bash

# 📝 Script helper pour commits conventionnels
# Facilite l'écriture de commits suivant la convention Conventional Commits

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

function show_help() {
    echo "📝 Script de Commit Conventionnel - Smart Lighting"
    echo ""
    echo "Usage: ./commit.sh [type] [scope] [description]"
    echo ""
    echo "Types disponibles:"
    echo "  feat     ⭐ Nouvelle fonctionnalité"
    echo "  fix      🐛 Correction de bug"
    echo "  docs     📚 Documentation"
    echo "  style    💄 Formatage, style (pas de changement logique)"
    echo "  refactor ♻️  Refactoring (pas de feat/fix)"
    echo "  test     🧪 Ajout/modification de tests"
    echo "  chore    🔧 Maintenance, outils, config"
    echo "  perf     ⚡ Amélioration de performance"
    echo "  ci       👷 CI/CD"
    echo "  build    📦 Build système"
    echo ""
    echo "Scopes suggérés:"
    echo "  api, mobile, infra, ci, deploy, auth, ui, db"
    echo ""
    echo "Exemples:"
    echo "  ./commit.sh feat api \"ajouter endpoint de luminosité\""
    echo "  ./commit.sh fix mobile \"corriger crash au démarrage\""
    echo "  ./commit.sh docs \"mettre à jour README\""
}

function interactive_commit() {
    echo -e "${BLUE}📝 Commit Interactif${NC}"
    echo ""
    
    # Type
    echo "Type de changement:"
    echo "1) feat     ⭐ Nouvelle fonctionnalité"
    echo "2) fix      🐛 Correction de bug"
    echo "3) docs     📚 Documentation"
    echo "4) style    💄 Formatage, style"
    echo "5) refactor ♻️  Refactoring"
    echo "6) test     🧪 Tests"
    echo "7) chore    🔧 Maintenance"
    echo "8) perf     ⚡ Performance"
    echo "9) ci       👷 CI/CD"
    echo "10) build   📦 Build"
    read -p "Choix [1-10]: " type_choice
    
    case $type_choice in
        1) TYPE="feat" ;;
        2) TYPE="fix" ;;
        3) TYPE="docs" ;;
        4) TYPE="style" ;;
        5) TYPE="refactor" ;;
        6) TYPE="test" ;;
        7) TYPE="chore" ;;
        8) TYPE="perf" ;;
        9) TYPE="ci" ;;
        10) TYPE="build" ;;
        *) echo "Choix invalide"; exit 1 ;;
    esac
    
    # Scope (optionnel)
    echo ""
    echo "Scope (optionnel, ex: api, mobile, infra):"
    read -p "Scope: " SCOPE
    
    # Description
    echo ""
    read -p "Description courte: " DESCRIPTION
    
    # Description longue (optionnelle)
    echo ""
    echo "Description longue (optionnelle, Entrée pour passer):"
    read -p "Body: " BODY
    
    # Breaking change
    echo ""
    read -p "Breaking change? [y/N]: " BREAKING
    
    # Construire le message
    if [[ -n "$SCOPE" ]]; then
        MESSAGE="$TYPE($SCOPE): $DESCRIPTION"
    else
        MESSAGE="$TYPE: $DESCRIPTION"
    fi
    
    # Ajouter body si présent
    if [[ -n "$BODY" ]]; then
        MESSAGE="$MESSAGE

$BODY"
    fi
    
    # Ajouter breaking change si présent
    if [[ "$BREAKING" =~ ^[Yy]$ ]]; then
        MESSAGE="$MESSAGE

BREAKING CHANGE: $DESCRIPTION"
    fi
    
    # Afficher et confirmer
    echo ""
    echo -e "${YELLOW}Message de commit:${NC}"
    echo "─────────────────────"
    echo "$MESSAGE"
    echo "─────────────────────"
    echo ""
    read -p "Confirmer ce commit? [Y/n]: " confirm
    
    if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
        git add .
        git commit -m "$MESSAGE"
        echo -e "${GREEN}✅ Commit créé avec succès!${NC}"
    else
        echo "Commit annulé"
    fi
}

# Script principal
if [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_help
    exit 0
fi

if [[ $# -eq 0 ]]; then
    interactive_commit
elif [[ $# -eq 3 ]]; then
    # Mode direct: type scope description
    TYPE="$1"
    SCOPE="$2"
    DESCRIPTION="$3"
    MESSAGE="$TYPE($SCOPE): $DESCRIPTION"
    
    git add .
    git commit -m "$MESSAGE"
    echo -e "${GREEN}✅ Commit: $MESSAGE${NC}"
elif [[ $# -eq 2 ]]; then
    # Mode direct sans scope: type description
    TYPE="$1"
    DESCRIPTION="$2"
    MESSAGE="$TYPE: $DESCRIPTION"
    
    git add .
    git commit -m "$MESSAGE"
    echo -e "${GREEN}✅ Commit: $MESSAGE${NC}"
else
    echo "Usage incorrect. Utilisez ./commit.sh help pour voir l'aide"
    exit 1
fi 