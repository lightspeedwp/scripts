---
applyTo: '**'
description: 'Prompt for Husky setup and integration for linting and quality checks.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['husky', 'linting', 'automation']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Husky Implementation Documentation Prompt

## Role

You are a workflow automation specialist. Create a prompt to guide the setup and integration of Husky for automated linting and quality checks in the LightSpeed WP scripts repository.

## Purpose

Ensure Husky is configured to run linting, formatting, and test checks on relevant git hooks, improving code quality and preventing errors before commits and pushes. Integrate all required linters and test runners, and document the setup for contributors.

## Checklist


## Current Repository State & Action Items

- Husky and lint-staged are not yet installed or configured in this branch.
- No pre-commit or pre-push hooks are present.
- `package.json` does not include Husky setup or scripts for hooks.

**Action:** Install Husky and lint-staged, add setup to `package.json`, create hooks for linting, formatting, and tests, and document the process in README files.

## Husky Setup Prompt Template

### Context

Husky must be set up to:

- Run linting and formatting checks on pre-commit
- Run tests and additional checks on pre-push
- Prevent commits and pushes if checks fail
- Document setup and usage for contributors

### Steps

1. Install Husky:

   ```sh
   npm install --save-dev husky
   npx husky install
   ```

2. Add Husky initialization to `package.json` scripts:

   ```json
   "scripts": {
     "prepare": "husky install"
   }
   ```

3. Create pre-commit hook for linting and formatting:

   ```sh
   npx husky add .husky/pre-commit "npm run lint && npm run format"
   ```

4. Create pre-push hook for running tests:

   ```sh
   npx husky add .husky/pre-push "npm test"
   ```

5. Integrate additional linters and test runners as needed (ShellCheck, markdownlint, Jest, Bats, Pytest)
6. Document Husky setup and usage in project README files
7. Validate hook execution and error handling
8. Commit changes with a message such as:

   ```sh
   git commit -am "Add Husky hooks for linting, formatting, and tests"
   ```

### Validation Steps



Use this prompt to guide and document all Husky setup and integration operations, ensuring automated quality checks and improved code standards across the repository. Use this as a template for future Husky or pre-commit hook integrations.
