#!/bin/bash

# Script pour la gestion des versions et releases

# Fonction pour récupérer la dernière version taguée
get_latest_version() {
    git describe --tags --abbrev=0
}

# Fonction pour générer le changelog
generate_changelog() {
    echo "## Changelog" > CHANGELOG.md
    echo "" >> CHANGELOG.md
    git log --pretty=format:"- %s" --abbrev-commit --date=short > CHANGELOG.md
}

# Fonction pour déterminer la prochaine version
# Prend en compte les commits pour déterminer si c'est un changement majeur, mineur ou patch
get_next_version() {
    local latest_version=$(get_latest_version)
    local major minor patch

    # Récupérer la version actuelle en MAJOR.MINOR.PATCH
    IFS='.' read -r major minor patch <<< "$latest_version"

    # Incrémentation de la version en fonction des commits
    # Cette logique est un exemple de base : tu peux l'ajuster en fonction de ta gestion des commits
    if git log --oneline --grep='BREAKING CHANGE'; then
        # Incrémenter MAJOR pour un breaking change
        ((major++))
        minor=0
        patch=0
    elif git log --oneline --grep='feat'; then
        # Incrémenter MINOR pour les nouvelles fonctionnalités
        ((minor++))
        patch=0
    else
        # Incrémenter PATCH pour les corrections de bugs
        ((patch++))
    fi

    # Retourne la prochaine version
    echo "$major.$minor.$patch"
}

# Création du changelog
generate_changelog

# Déterminer la prochaine version
next_version=$(get_next_version)

# Créer un nouveau tag
git tag -a "v$next_version" -m "Release v$next_version"

# Pousser le tag
git push origin "v$next_version"

# Committer et pousser le changelog
git add CHANGELOG.md
git commit -m "docs(changelog): update changelog for v$next_version"
git push origin main
