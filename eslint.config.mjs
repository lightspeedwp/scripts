// ESLint v9+ configuration for LightSpeed WP scripts repo
// See: https://eslint.org/docs/latest/use/configure/migration-guide

import js from '@eslint/js';
import prettierConfig from 'eslint-config-prettier';
import prettierPlugin from 'eslint-plugin-prettier';
import tseslint from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';

export default [
  js.configs.recommended,
  prettierConfig,
  {
    plugins: {
      prettier: prettierPlugin,
      '@typescript-eslint': tseslint,
    },
    files: ['**/*.ts'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parser: tsParser,
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
      'prettier/prettier': 'error',
      '@typescript-eslint/no-unused-vars': 'warn',
    },
  },
  {
    plugins: {
      prettier: prettierPlugin,
    },
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
      'prettier/prettier': 'error',
    },
  },
];
