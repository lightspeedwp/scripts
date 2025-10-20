// ESLint v9+ configuration for LightSpeed WP scripts repo
// See: https://eslint.org/docs/latest/use/configure/migration-guide

import js from '@eslint/js';
import prettier from 'eslint-config-prettier';

export default [
    js.configs.recommended,
    prettier,
    {
        files: ['**/*.{js,ts}'],
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
