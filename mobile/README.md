# Smart Lighting - Application Mobile Flutter

Une application mobile Flutter permettant de contrôler des lampes connectées via une API REST.

![Version](https://img.shields.io/badge/version-1.0.0-blue)

## Description

Smart Lighting est une application mobile développée avec Flutter qui permet aux utilisateurs de contrôler l'état (allumé/éteint) de lampes connectées. L'application communique avec un backend Node.js pour récupérer et mettre à jour l'état des lampes.

## Fonctionnalités

- Affichage de l'état actuel de la lampe (allumée/éteinte)
- Bouton pour activer/désactiver la lampe
- Animation visuelle lors du changement d'état
- Indication de l'état de connexion avec le serveur
- Interface utilisateur moderne avec thème sombre

## Technologies utilisées

- **Flutter** - Framework UI multiplateforme
- **Dart** - Langage de programmation
- **http** - Package pour les requêtes HTTP vers le backend
- **flutter_animate** - Package pour les animations fluides
- **google_fonts** - Package pour l'utilisation de polices Google

## Prérequis

- Flutter SDK (version récente recommandée)
- Dart SDK
- Un éditeur de code (Visual Studio Code, Android Studio, etc.)
- Un appareil ou émulateur Android/iOS pour tester l'application

## Installation

1. Assurez-vous que Flutter est correctement installé sur votre machine
   ```
   flutter doctor
   ```

2. Clonez ce dépôt

3. Installez les dépendances
   ```
   flutter pub get
   ```

4. Lancez l'application
   ```
   flutter run
   ```

## Configuration

Par défaut, l'application se connecte au backend sur l'adresse `http://10.0.2.2:5000/api` qui correspond à l'adresse localhost de votre machine hôte lorsque vous utilisez un émulateur Android.

Pour utiliser un appareil physique ou modifier l'URL du backend, modifiez la variable `apiUrl` dans `lib/main.dart`.

## Structure du projet

- `lib/main.dart` - Point d'entrée de l'application contenant toute la logique et l'UI

## API utilisée

L'application utilise l'API REST du backend avec les endpoints suivants :

- `GET /api/lamps` - Récupère la liste des lampes et leur état
- `PUT /api/lamps/:id` - Inverse l'état d'une lampe spécifique

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des pull requests.

## Licence

Ce projet est sous licence MIT.
