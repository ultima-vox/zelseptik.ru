import js from '@eslint/js';

export default [
  js.configs.recommended,
  {
    files: ['templates/**/*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      // Скрипты сайта — классические IIFE, не ES-модули.
      sourceType: 'script',
      globals: {
        window: 'readonly',
        document: 'readonly',
        navigator: 'readonly',
        console: 'readonly',
        fetch: 'readonly',
        FormData: 'readonly',
        IntersectionObserver: 'readonly',
        requestAnimationFrame: 'readonly',
        setTimeout: 'readonly',
        clearTimeout: 'readonly',
        ymaps3: 'readonly',
        grecaptcha: 'readonly',
        gtag: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    },
  },
];
