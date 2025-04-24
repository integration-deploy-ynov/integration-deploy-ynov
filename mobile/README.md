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

## Tests

L'application est livrée avec une suite complète de tests pour assurer la qualité et la stabilité du code. Les tests sont organisés en plusieurs catégories:

### Tests API (`api_test.dart`)

Ces tests vérifient les interactions avec le backend:

- Test de récupération de l'état des lampes (`fetchLamps`)
  - Succès de la réponse avec données correctes
  - Gestion des erreurs serveur (code 500)
  - Gestion des erreurs de connexion (exceptions réseau)

- Test de mise à jour de l'état d'une lampe (`toggleLamp`)
  - Succès de la mise à jour avec réponse correcte
  - Gestion des erreurs serveur
  - Gestion des erreurs de connexion

### Tests de Widget (`widget_test.dart`)

Ces tests vérifient le comportement de l'interface utilisateur et ses interactions:

- Affichage correct du titre et du statut de la lampe
- Comportement de l'interface lors de l'appui sur le bouton d'alimentation
- Affichage de l'indicateur de chargement pendant les opérations réseau

### Tests UI (`ui_test.dart`)

Ces tests se concentrent sur l'apparence et les éléments visuels de l'application:

- Vérification du thème et des éléments visuels principaux
- Affichage correct du statut de la lampe selon son état
- Affichage des états d'erreur du serveur
- Affichage de l'état déconnecté en cas d'erreur réseau
- Affichage correct de l'ID de la lampe

### Tests d'Animation (`animation_test.dart`)

Ces tests vérifient le bon fonctionnement des animations dans l'application:

- Animation de l'icône de lampe lors du changement d'état
- Animation de fondu (fade-in) du conteneur de statut
- Animation d'échelle (scale) du bouton d'alimentation au chargement

### Outils de Test

Pour faciliter les tests, nous utilisons:

- **mockito** - Pour créer des mocks des services HTTP
- **http_mock_adapter** - Pour simuler les réponses HTTP
- **flutter_test** - Framework de test intégré à Flutter

### Exécution des Tests

Pour exécuter tous les tests:

```bash
flutter test
```

Pour exécuter un fichier de test spécifique:

```bash
flutter test test/api_test.dart
flutter test test/ui_test.dart
flutter test test/widget_test.dart
flutter test test/animation_test.dart
```

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
- `test/` - Répertoire contenant tous les tests de l'application
  - `api_test.dart` - Tests des appels API
  - `ui_test.dart` - Tests de l'interface utilisateur
  - `widget_test.dart` - Tests des widgets
  - `animation_test.dart` - Tests des animations
  - `mocks/` - Répertoire contenant les mocks pour les tests

## API utilisée

L'application utilise l'API REST du backend avec les endpoints suivants :

- `GET /api/lamps` - Récupère la liste des lampes et leur état
- `PUT /api/lamps/:id` - Inverse l'état d'une lampe spécifique

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des pull requests.

## Licence

Ce projet est sous licence MIT.
