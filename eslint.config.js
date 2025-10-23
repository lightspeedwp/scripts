// ESLint v9+ configuration for LightSpeed WP scripts repo
// See: https://eslint.org/docs/latest/use/configure/migration-guide

import js from '@eslint/js';
import prettierConfig from 'eslint-config-prettier';
import prettierPlugin from 'eslint-plugin-prettier';
import tseslint from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';
import globals from 'globals';

export default [
    {
        ignores: [
            'node_modules/**',
            'dist/**',
            'build/**',
            'coverage/**',
            '**/*.min.js',
            'logs/**',
        ],
    },
    js.configs.recommended,
    prettierConfig,
    // JavaScript files
    {
        files: ['**/*.js', '**/*.mjs'],
        languageOptions: {
            ecmaVersion: 2022,
            sourceType: 'module',
            globals: {
                ...globals.node,
            },
        },
        plugins: {
            prettier: prettierPlugin,
        },
        rules: {
            ...js.configs.recommended.rules,
            'prettier/prettier': 'error',
            curly: ['error', 'all'],
            'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
        },
    },
    // Jest test files configuration
    {
        files: ['**/*.test.js', '**/tests/**/*.js'],
        languageOptions: {
            ecmaVersion: 2022,
            sourceType: 'module',
            globals: {
                ...globals.node,
                ...globals.jest,
            },
        },
        plugins: {
            prettier: prettierPlugin,
        },
        rules: {
            ...js.configs.recommended.rules,
            'prettier/prettier': 'error',
            curly: ['error', 'all'],
            'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
        },
    },
    // GitHub Actions scripts
    {
        files: ['.github/**/*.js'],
        languageOptions: {
            ecmaVersion: 2022,
            sourceType: 'script',
            globals: {
                ...globals.node,
                // GitHub Actions globals
                github: 'readonly',
                context: 'readonly',
                core: 'readonly',
                Octokit: 'readonly',
            },
        },
        plugins: {
            prettier: prettierPlugin,
        },
        rules: {
            ...js.configs.recommended.rules,
            'prettier/prettier': 'error',
            curly: ['error', 'all'],
            'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
        },
    },
    // TypeScript files
    {
        files: ['**/*.ts'],
        plugins: {
            '@typescript-eslint': tseslint,
            prettier: prettierPlugin,
        },
        languageOptions: {
            ecmaVersion: 'latest',
            sourceType: 'module',
            parser: tsParser,
            parserOptions: {
                project: './tsconfig.json',
            },
        },
        rules: {
            // Disable base ESLint rules that conflict with TypeScript
            'no-unused-vars': 'off',
            '@typescript-eslint/no-unused-vars': 'warn',
            '@typescript-eslint/no-explicit-any': 'warn',
            '@typescript-eslint/prefer-nullish-coalescing': 'error',
            '@typescript-eslint/prefer-optional-chain': 'error',
            'no-console': 'off',
            'prettier/prettier': 'error',
        },
    },
    // Node.js specific files
    {
        files: ['scripts/**/*.js', '**/*.config.js', '**/*.config.mjs'],
        languageOptions: {
            globals: {
                process: 'readonly',
                Buffer: 'readonly',
                __dirname: 'readonly',
                __filename: 'readonly',
            },
        },
    },
    // Ignore patterns
    {
        ignores: [
            'node_modules/**',
            'dist/**',
            'build/**',
            'coverage/**',
            'logs/**',
            'test-results/**',
            'playwright-report/**',
            '.vscode/**',
        ],
    },
];
