#!/bin/bash

# 🚀 Script de release automatisé pour Smart Lighting System
# Gère les versions, tags Git, CHANGELOG et déploiement
set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Reset color

# Configuration
PROJECT_NAME="Smart Lighting System"
BACKEND_DIR="api/backend"
MOBILE_DIR="api/mobile"
VERSION_FILE="$BACKEND_DIR/package.json"
CHANGELOG_FILE="CHANGELOG.md"

# Fonctions utilitaires
function log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

function log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

function log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

function log_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

function check_git_status() {
    if [[ -n $(git status --porcelain) ]]; then
        log_error "Le dépôt contient des modifications non commitées. Veuillez commiter ou stash vos changements."
    fi
    log_success "Dépôt Git propre"
}

function get_current_version() {
    if [[ -f "$VERSION_FILE" ]]; then
        grep '"version"' "$VERSION_FILE" | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d ' '
    else
        echo "0.0.0"
    fi
}

function increment_version() {
    local version=$1
    local type=$2
    
    IFS='.' read -ra VERSION_PARTS <<< "$version"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    case $type in
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "patch"|*)
            patch=$((patch + 1))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

function update_version_in_file() {
    local new_version=$1
    local file=$2
    
    if [[ -f "$file" ]]; then
        sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$file"
        log_success "Version mise à jour dans $file: $new_version"
    fi
}

function update_changelog() {
    local version=$1
    local date=$(date +%Y-%m-%d)
    local temp_file=$(mktemp)
    
    # Lire le CHANGELOG existant
    if [[ -f "$CHANGELOG_FILE" ]]; then
        # Remplacer [Unreleased] par la nouvelle version
        sed "s/## \[Unreleased\]/## [$version] - $date/" "$CHANGELOG_FILE" > "$temp_file"
        
        # Ajouter une nouvelle section [Unreleased] au début
        {
            head -n 7 "$temp_file"
            echo ""
            echo "## [Unreleased]"
            echo ""
            echo "### Added"
            echo "- "
            echo ""
            tail -n +8 "$temp_file"
        } > "$CHANGELOG_FILE"
        
        rm "$temp_file"
        log_success "CHANGELOG.md mis à jour pour la version $version"
    else
        log_warning "CHANGELOG.md non trouvé, création d'un nouveau fichier"
    fi
}

function run_tests() {
    log_info "Exécution des tests..."
    
    if [[ -d "$BACKEND_DIR" ]]; then
        cd "$BACKEND_DIR"
        npm install --silent
        npm test
        cd - > /dev/null
        log_success "Tests backend réussis"
    fi
    
    # Tests mobiles si le dossier existe
    if [[ -d "$MOBILE_DIR" ]]; then
        cd "$MOBILE_DIR"
        if [[ -f "pubspec.yaml" ]]; then
            flutter pub get
            flutter test
            cd - > /dev/null
            log_success "Tests mobile réussis"
        fi
    fi
}

function create_git_tag() {
    local version=$1
    local tag="v$version"
    
    # Ajouter tous les fichiers modifiés
    git add .
    git commit -m "chore(release): bump version to $version

- Update version in package.json
- Update CHANGELOG.md
- Prepare release $tag"
    
    # Créer le tag
    git tag -a "$tag" -m "Release $tag

$(grep -A 10 "\[$version\]" "$CHANGELOG_FILE" | head -n 10)"
    
    log_success "Tag Git créé: $tag"
}

function deploy_application() {
    log_info "Déploiement de l'application..."
    
    # Déploiement via Ansible si disponible
    if [[ -f "ansible/deploy_api.yml" && -f "infra/inventory.ini" ]]; then
        ansible-playbook -i infra/inventory.ini ansible/deploy_api.yml
        log_success "Déploiement Ansible terminé"
    else
        log_warning "Configuration Ansible non trouvée, déploiement ignoré"
    fi
}

function show_release_summary() {
    local old_version=$1
    local new_version=$2
    
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${GREEN}🎉 RELEASE TERMINÉE AVEC SUCCÈS${NC}"
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${BLUE}Projet:${NC} $PROJECT_NAME"
    echo -e "${BLUE}Version précédente:${NC} $old_version"
    echo -e "${BLUE}Nouvelle version:${NC} v$new_version"
    echo -e "${BLUE}Tag Git:${NC} v$new_version"
    echo -e "${BLUE}Date:${NC} $(date)"
    echo ""
    echo -e "${YELLOW}Pour pousser vers le dépôt distant:${NC}"
    echo "  git push origin main"
    echo "  git push origin --tags"
    echo ""
    echo -e "${YELLOW}Fichiers modifiés:${NC}"
    echo "  ✓ $VERSION_FILE"
    echo "  ✓ $CHANGELOG_FILE"
    echo "════════════════════════════════════════════════════════════════"
}

# Menu principal
function show_menu() {
    echo "🚀 Script de Release - $PROJECT_NAME"
    echo ""
    echo "Type de release:"
    echo "1) 🔧 Patch (bug fixes) - incrémente X.Y.Z → X.Y.Z+1"
    echo "2) ⭐ Minor (nouvelles fonctionnalités) - incrémente X.Y.Z → X.Y+1.0"
    echo "3) 🚀 Major (breaking changes) - incrémente X.Y.Z → X+1.0.0"
    echo "4) 📋 Custom (version personnalisée)"
    echo "5) ❌ Annuler"
    echo ""
    read -p "Votre choix [1-5]: " choice
    
    case $choice in
        1) RELEASE_TYPE="patch" ;;
        2) RELEASE_TYPE="minor" ;;
        3) RELEASE_TYPE="major" ;;
        4) RELEASE_TYPE="custom" ;;
        5) echo "Release annulée"; exit 0 ;;
        *) log_error "Choix invalide" ;;
    esac
}

# Script principal
function main() {
    echo "🚀 Début du processus de release pour $PROJECT_NAME"
    echo ""
    
    # Vérifications préliminaires
    check_git_status
    
    # Obtenir la version actuelle
    CURRENT_VERSION=$(get_current_version)
    log_info "Version actuelle: $CURRENT_VERSION"
    
    # Menu de sélection du type de release
    if [[ -z "${1:-}" ]]; then
        show_menu
    else
        RELEASE_TYPE="$1"
    fi
    
    # Calculer la nouvelle version
    if [[ "$RELEASE_TYPE" == "custom" ]]; then
        read -p "Entrez la nouvelle version (ex: 2.1.0): " NEW_VERSION
    else
        NEW_VERSION=$(increment_version "$CURRENT_VERSION" "$RELEASE_TYPE")
    fi
    
    log_info "Nouvelle version: $NEW_VERSION"
    
    # Confirmation
    echo ""
    read -p "Confirmer la release $CURRENT_VERSION → $NEW_VERSION ? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_warning "Release annulée par l'utilisateur"
        exit 0
    fi
    
    # Processus de release
    log_info "🧪 Exécution des tests..."
    run_tests
    
    log_info "📝 Mise à jour des fichiers de version..."
    update_version_in_file "$NEW_VERSION" "$VERSION_FILE"
    
    log_info "📋 Mise à jour du CHANGELOG..."
    update_changelog "$NEW_VERSION"
    
    log_info "🏷️  Création du tag Git..."
    create_git_tag "$NEW_VERSION"
    
    log_info "🚀 Déploiement..."
    deploy_application
    
    # Résumé final
    show_release_summary "$CURRENT_VERSION" "$NEW_VERSION"
}

# Exécution du script
main "$@"
