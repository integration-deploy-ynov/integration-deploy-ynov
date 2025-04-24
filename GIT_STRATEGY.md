# Git Strategy for Smart Lighting Project

Ce document décrit la stratégie Git à suivre pour le projet Smart Lighting. Il définit les rôles, les procédures pour la création de features, les règles de merge/rebase, et le format des messages de commits.

## Rôles et Responsabilités

### Lead Developer
- Responsable de la structure globale du projet
- Approuve les pull requests pour la branche `main`
- Définit les standards de code et les bonnes pratiques
- Gère les releases et le versioning

### Frontend Developer
- Travaille principalement sur l'application Flutter (`mobile/`)
- Crée et maintient les fonctionnalités UI/UX
- Effectue des tests sur la partie frontend
- Assure la compatibilité avec le backend

### Backend Developer
- Travaille principalement sur l'API Node.js (`backend/`)
- Développe et maintient les endpoints d'API
- Gère les modèles de données et la structure de la BDD
- Assure les performances et la sécurité du backend

### QA Engineer
- Valide les fonctionnalités avant merge dans `main`
- Effectue les tests manuels et automatisés
- Identifie et rapporte les bugs
- Valide les critères d'acceptance

### DevOps Engineer
- Configure et maintient les pipelines CI/CD
- Gère les environnements de déploiement
- Assure la qualité et la sécurité du processus de déploiement
- Optimise les workflows d'intégration

## Procédure de Création de Feature

1. **Création de la Branche**
   - Partir toujours d'une branche `develop` à jour
   - Nommer la branche suivant la convention: `feature/nom-de-la-feature`
   - Pour les correctifs: `fix/description-du-fix`
   
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/nom-de-la-feature
   ```

2. **Développement**
   - Faire des commits fréquents et atomiques
   - Suivre les standards de code définis pour le projet
   - S'assurer que tous les tests passent localement

3. **Mise à Jour Régulière**
   - Rebaser régulièrement avec `develop` pour éviter les conflits majeurs
   
   ```bash
   git fetch origin develop
   git rebase origin/develop
   ```

4. **Préparation de la Pull Request**
   - S'assurer que tous les tests passent
   - Faire un rebase final avec `develop`
   - Push de la branche sur le dépôt distant
   
   ```bash
   git push origin feature/nom-de-la-feature
   ```

5. **Création de la Pull Request**
   - Soumettre une PR vers la branche `develop`
   - Inclure une description détaillée de la feature
   - Référencer les numéros d'issues associés
   - Assigner les reviewers appropriés

6. **Revue et Validation**
   - Au moins un reviewer doit approuver la PR
   - Résoudre tous les commentaires et suggestions
   - QA vérifie que la feature répond aux critères d'acceptance
   - CI/CD pipeline doit passer avec succès

7. **Merge**
   - Une fois approuvée, la PR peut être fusionnée dans `develop`
   - Utiliser "Squash and merge" pour garder l'historique propre
   - Supprimer la branche feature après le merge

## Règles de Merge et de Rebase

### Stratégie Générale: Git Flow
Nous utilisons une version adaptée de Git Flow:

- `main`: Branche de production stable
- `develop`: Branche d'intégration principale
- `feature/*`: Branches de développement de fonctionnalités
- `fix/*`: Branches pour les correctifs
- `release/*`: Branches de préparation de release
- `hotfix/*`: Correctifs urgents pour production

### Règles de Merge

1. **Vers `develop`**
   - Toujours via Pull Request
   - Nécessite au moins une approbation
   - Tests CI doivent passer
   - Privilégier "Squash and merge" pour un historique propre

2. **Vers `main`**
   - Uniquement depuis `release/*` ou `hotfix/*`
   - Nécessite l'approbation du Lead Developer
   - Tests de régression complets doivent passer
   - Toujours utiliser "Merge commit" (pas de squash)
   - Toujours ajouter un tag de version

3. **Conflits de Merge**
   - Privilégier la résolution en local avant de pousser
   - Consulter l'auteur du code en conflit si nécessaire
   - Documenter les décisions importantes dans le message de commit

### Règles de Rebase

1. **Quand Utiliser Rebase**
   - Pour mettre à jour une branche feature avec les derniers changements de `develop`
   - Pour nettoyer l'historique d'une branche feature avant la PR
   - Pour réorganiser les commits d'une feature pour plus de clarté

2. **Quand Éviter Rebase**
   - Sur des branches partagées (comme `develop` ou `main`)
   - Sur des branches où d'autres développeurs travaillent activement
   
3. **Rebase Interactif**
   - Utiliser pour consolider les petits commits et nettoyer l'historique
   
   ```bash
   git rebase -i HEAD~n  # où n est le nombre de commits à modifier
   ```

4. **Après un Rebase**
   - Force push uniquement sur les branches de feature personnelles
   - Toujours notifier les collaborateurs en cas de force push sur une branche partagée
   
   ```bash
   git push origin feature/nom-de-la-feature --force-with-lease
   ```

## Format des Messages de Commit

Nous utilisons le format Conventional Commits pour standardiser les messages:

```
<type>(<scope>): <description>

[corps optionnel]

[pied de page optionnel]
```

### Types

- **feat**: Nouvelle fonctionnalité
- **fix**: Correction de bug
- **docs**: Modification de documentation
- **style**: Modifications de formatage (pas de changement de code)
- **refactor**: Refactorisation du code
- **perf**: Améliorations de performance
- **test**: Ajout ou correction de tests
- **build**: Modifications du système de build ou des dépendances
- **ci**: Modifications de la configuration CI
- **chore**: Autres modifications (qui ne modifient pas src ou test)

### Scope

Le scope indique la partie du projet affectée:

- `mobile`: Application Flutter
- `backend`: API Node.js
- `docs`: Documentation
- `tests`: Tests
- `ci`: Intégration continue
- `deploy`: Déploiement

### Exemples

```
feat(mobile): ajouter animation lors du changement d'état de la lampe

fix(backend): corriger le problème de connexion à la base de données

docs(readme): mettre à jour les instructions d'installation

test(mobile): ajouter tests pour l'UI des lampes

refactor(backend): réorganiser la structure des routes API
```

### Messages de Corps de Commit

- Utiliser l'impératif présent: "ajouter" plutôt que "ajouté"
- Expliquer le "pourquoi" plutôt que le "comment"
- Limiter la première ligne à 72 caractères
- Séparer le sujet du corps par une ligne vide
- Limiter les lignes du corps à 100 caractères

### Pied de Page

- Référencer les issues: `Fixes #123` ou `Closes #456`
- Mentionner les breaking changes: `BREAKING CHANGE: description du changement`

## Workflow de Release

1. **Préparer la Release**
   - Créer une branche `release/vX.Y.Z` depuis `develop`
   - Mettre à jour les numéros de version et changelogs
   - Effectuer les derniers correctifs si nécessaire
   - Pousser la branche et créer une PR vers `main`

2. **Valider la Release**
   - Exécuter les tests de régression
   - Vérifier la documentation
   - Valider en environnement de staging

3. **Finaliser la Release**
   - Merger la branche `release/vX.Y.Z` dans `main`
   - Créer un tag git avec la version: `git tag vX.Y.Z`
   - Merger également `release/vX.Y.Z` dans `develop`
   - Pousser les tags: `git push origin --tags`

4. **Après la Release**
   - Supprimer la branche `release/vX.Y.Z`
   - Déployer en production via CI/CD
   - Annoncer la release