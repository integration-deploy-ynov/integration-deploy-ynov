# Rapport de Déploiement – API Node.js

## 1. Architecture Infrastructure & Choix du Provider

### Provider choisi : Google Cloud Platform (GCP)

Le provider utilisé pour ce projet est **Google Cloud Platform (GCP)**. Ce choix repose sur plusieurs critères :

- Offre gratuite avec une instance e2-micro, suffisante pour des tests/démonstrations.
- Intégration facile avec des outils IaC comme **Terraform**.
- Documentation complète et grande communauté.

### Architecture déployée

- **Une machine virtuelle (VM)** Ubuntu 22.04 provisionnée via Terraform.
- **Un réseau VPC personnalisé** avec des règles de pare-feu autorisant :
  - Le port `22` (SSH)
  - Le port `3000` (exposition de l’API Node.js)
- **Déploiement de l’API** avec Ansible sur la VM
- **Gestion de processus avec PM2** pour que l’API reste disponible après reboot

---

## 2. Fonctionnement de la configuration Terraform & du playbook Ansible

### 📁 Terraform (`infra/`)

#### Fichiers clés :
- `main.tf` : configuration des ressources (VM, firewall, réseau)
- `variables.tf` : déclaration des variables utilisées
- `terraform.tfvars` : valeurs concrètes (non commit si sensibles)

#### Comportement :
- Initialisation : `terraform init`
- Provisionnement : `terraform apply`
- Une fois terminé, une VM est créée avec une IP publique (exposée dans `inventory.ini` pour Ansible)

---

### 📁 Ansible (`ansible/`)

#### Fichiers :
- `inventory.ini` : IP publique de la VM
- `deploy.yml` : Playbook de déploiement complet de l’API

#### Étapes principales du `deploy.yml` :
1. Mise à jour de la VM (`apt update`)
2. Installation de dépendances de base (`git`, `curl`, `build-essential`, etc.)
3. Installation de Node.js LTS
4. Clonage ou mise à jour du dépôt Git contenant l’API
5. Installation des dépendances `npm`
6. Installation de `pm2` (gestionnaire de processus)
7. Lancement de l’API avec `pm2`
8. Configuration de `pm2` pour démarrer automatiquement au boot
9. Sauvegarde de la configuration `pm2`

---

## 3. Pipeline CI/CD & Logs

### 📁 CI/CD (`.github/workflows/ci.yml`)

#### Objectif :
- Exécuter automatiquement les tests de l’API à chaque push/pull request
- Garantir que le code est fonctionnel avant le déploiement

#### Déclencheurs :
- `push` ou `pull_request` sur la branche `main`

#### Étapes du pipeline :
1. Checkout du code
2. Setup de Node.js (version 18)
3. Installation des dépendances `npm`
4. Exécution des tests (`npm test`)

#### Exemple de pipeline (`ci.yml`) :

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 23
      - run: npm install
        working-directory: ./api/backend
      - run: npm test
        working-directory: ./api/backend
