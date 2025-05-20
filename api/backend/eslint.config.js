module.exports = [
  {
    languageOptions: {
      ecmaVersion: 2021, // Utilise ECMAScript 2021
      sourceType: 'module', // Utilise les modules ES6
      globals: {
        console: 'readonly', // Déclare `console` comme une variable globale en lecture seule
        process: 'readonly', // Déclare `process` comme une variable globale en lecture seule
        __dirname: 'readonly' // Déclare `__dirname` comme une variable globale en lecture seule
      }
    },
    rules: {
      // Règles recommandées par ESLint
      'no-console': 'warn', // Avertissement pour l'utilisation de `console.log`
      indent: ['error', 2], // Utilise 2 espaces pour l'indentation
      quotes: ['error', 'single'], // Utilise des guillemets simples
      semi: ['error', 'always'], // Nécessite un point-virgule à la fin des instructions
      'no-unused-vars': ['warn'], // Avertissement pour les variables inutilisées
      'no-trailing-spaces': 'error', // Pas d'espaces inutiles à la fin des lignes
      eqeqeq: 'error', // Nécessite l'utilisation de l'opérateur `===`
      curly: 'error', // Oblige à utiliser les accolades pour les blocs
      'no-magic-numbers': 'off' // Désactive la règle pour les "nombres magiques"
    }
  }
];
