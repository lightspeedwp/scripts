# Configuration Files Reference

This document explains all configuration files in the LightSpeed WP Scripts repository, their purposes, and how they interact with each other.

## Overview

This repository uses multiple configuration files to maintain code quality, enforce standards, and automate workflows. Each file serves a specific purpose in the development ecosystem.

## Core Configuration Files

### Package Management

#### `package.json`

- **Purpose**: Main Node.js project configuration and dependency management
- **Key Sections**:
    - Scripts: npm commands for testing, linting, formatting, and deployment
    - Dependencies: Runtime dependencies for GitHub Actions
    - DevDependencies: Development tools and linting packages
- **Standards**: Follows LightSpeed WP naming conventions and semantic versioning
- **Integration**: Works with all other tools via npm scripts

#### `package-lock.json`

- **Purpose**: Locks exact dependency versions for reproducible installs
- **Management**: Auto-generated, should not be manually edited
- **Importance**: Critical for consistent development environments

#### `.npmrc`

- **Purpose**: npm behavior configuration
- **Key Settings**:
    - `save-exact=true`: Saves exact versions instead of ranges
    - `package-lock=true`: Ensures lock file creation
    - `fund=false`: Disables funding messages
    - `engine-strict=true`: Enforces Node.js version requirements

#### `.nvmrc`

- **Purpose**: Specifies Node.js version (20.x) for nvm
- **Usage**: Run `nvm use` to switch to correct Node.js version
- **Integration**: Used by CI/CD and development environments

### Code Quality & Linting

#### `eslint.config.js`

- **Purpose**: Modern ESLint v9+ configuration using flat config system
- **Features**:
    - Separate configs for JavaScript, TypeScript, Jest, GitHub Actions
    - Prettier integration for consistent formatting
    - Environment-specific globals and rules
- **Replaces**: Legacy `.eslintrc.json` (removed for conflicts)

#### `.prettierrc.js`

- **Purpose**: Code formatting configuration
- **Standards**:
    - 4-space indentation (matches EditorConfig)
    - Single quotes, trailing commas
    - 80-character line width
- **Integration**: Works with ESLint via eslint-plugin-prettier

#### `.prettierignore`

- **Purpose**: Excludes files/directories from Prettier formatting
- **Includes**: node_modules, build artifacts, coverage reports, logs

#### `.editorconfig`

- **Purpose**: Cross-editor consistency for basic formatting
- **Settings**:
    - UTF-8 encoding, LF line endings
    - 4-space indentation for all files
    - Trim trailing whitespace, insert final newline

#### `.markdownlint.json`

- **Purpose**: Markdown file linting configuration
- **Rules**:
    - Disables line length enforcement (MD013)
    - Allows inline HTML (MD033)
- **Usage**: Via markdownlint-cli in npm scripts

#### `.shellcheckrc`

- **Purpose**: ShellCheck configuration for shell script analysis
- **Disabled Checks**:
    - SC2034: Unused variables (common in sourced scripts)
    - SC2039: Bash-specific features (explicitly using bash)
    - SC1090/1091: Sourcing checks for dynamic includes
- **Target**: Explicitly set to bash dialect

### Testing Configuration

#### `jest.config.js`

- **Purpose**: Jest testing framework configuration
- **Settings**:
    - Node.js test environment
    - Tests in `tests/**/*.test.js`
    - Verbose output enabled
- **Coverage**: Configured for optional coverage reporting

#### `playwright.config.js`

- **Purpose**: End-to-end testing with Playwright
- **Configuration**:
    - Test directory: `./tests/e2e`
    - Base URL: Configurable via environment variable
    - Chrome browser target

### Git & Commit Standards

#### `commitlint.config.js`

- **Purpose**: Enforces conventional commit message format
- **Types**: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
- **Rules**:
    - Lowercase subjects, max 100 characters
    - Body max 120 characters per line
- **Integration**: Used with Husky git hooks

#### `.gitignore`

- **Purpose**: Excludes files from version control
- **Categories**:
    - Logs and temporary files
    - Node.js modules and build artifacts
    - Environment files and secrets
    - Editor and OS generated files
    - Test outputs and coverage reports

### Package Validation

#### `.npmpackagejsonlintrc.json`

- **Purpose**: Validates package.json structure and content
- **Enforces**:
    - Required fields (name, version, author, description, license, repository)
    - Valid license values (GPL-3.0-or-later, MIT, ISC, Apache-2.0)
    - Dependency format preferences
- **Integration**: Run via npm scripts

### Project Metadata

#### `.all-contributorsrc`

- **Purpose**: Configuration for all-contributors automation
- **Settings**:
    - Project name and repository information
    - Contributor display format (7 per line, 100px avatars)
    - Manual commit control (commit: false)
- **Usage**: Manages contributor recognition in README.md

#### `tsconfig.json`

- **Purpose**: TypeScript configuration for type checking
- **Target**: ES2022 with modern module resolution
- **Includes**: src and types directories
- **Note**: No emit configuration (type checking only)

## GitHub Integration

#### `.coderabbit.yml`

- **Purpose**: CodeRabbit AI code review configuration
- **Features**:
    - Automated PR reviews and labeling
    - Path-specific instructions for different file types
    - Required status checks and approval workflows
- **Integration**: Works with GitHub Actions and PR workflows

#### `.github/` Directory

Contains GitHub-specific configurations:

- Issue and PR templates
- Workflow files
- Custom instructions for Copilot and automation

## Workflow Integration

### Development Workflow

1. **Setup**: Use `.nvmrc` and `package.json` for environment
2. **Code**: Follow `.editorconfig` and `.prettierrc.js` formatting
3. **Commit**: Validated by `commitlint.config.js` via Husky
4. **Test**: Run via `jest.config.js` and shell script testing
5. **Lint**: Multiple tools via `eslint.config.js`, `.markdownlint.json`, `.shellcheckrc`
6. **Review**: Automated via `.coderabbit.yml`

### CI/CD Integration

All configurations work together in GitHub Actions:

- Node.js version from `.nvmrc`
- Dependencies from `package.json`
- Linting via npm scripts
- Testing with Jest and Bats
- Code review via CodeRabbit

## Maintenance

### Adding New Configuration

1. Follow naming conventions (dot-prefixed for tools)
2. Document purpose and integration in this README
3. Add to appropriate npm scripts if needed
4. Test with existing workflow

### Updating Configuration

1. Check integration with other tools
2. Test changes locally before committing
3. Update documentation if behavior changes
4. Consider backward compatibility

### Removing Configuration

1. Verify no dependencies in other files
2. Remove from npm scripts and workflows
3. Update this documentation
4. Test complete workflow after removal

## Troubleshooting

### Common Issues

1. **ESLint conflicts**: Use only `eslint.config.js` (flat config)
2. **Prettier formatting**: Check `.editorconfig` alignment
3. **Node version**: Use `nvm use` to match `.nvmrc`
4. **Package issues**: Run `npm ci` for clean install

### File Precedence

When multiple configs exist for the same tool:

1. Tool looks for specific config files first
2. Falls back to package.json sections
3. Uses default settings if none found

## Standards Compliance

All configurations follow LightSpeed WP standards:

- 4-space indentation across all tools
- GPL-3.0-or-later licensing
- Conventional commit messages
- Comprehensive testing requirements
- Automated quality gates

---

**Maintenance**: Update this file when adding, removing, or significantly modifying configuration files.
**Version**: 1.0.0 (matches package.json version)
**Last Updated**: October 2025
