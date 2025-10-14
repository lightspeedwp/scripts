# Contributing Guide

## Markdown Linting

All Markdown files must pass linting using `markdownlint` before merging any pull request. Linting is enforced via GitHub Actions and must be a required status check for all release branches (main, develop, release/\*). Fix all markdownlint errors before requesting review or merging.

To run locally:

````bash
npm run lint:md
```markdown

Thank you for your interest in contributing to the LightSpeed WP automation repository! This document provides guidelines and information for contributors.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch from `main`
4. Make your changes following our guidelines
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

### Prerequisites

- Bash 4.0 or higher
- Git
- Bats (for testing)
- VSCode with MCP extension (recommended)

### Installation

```bash
git clone https://github.com/lightspeedwp/lightspeedwp-automation.git
cd lightspeedwp-automation

# Install Bats for testing
sudo apt-get install bats  # Ubuntu/Debian
# or
brew install bats-core     # macOS

# Make scripts executable
find . -name "*.sh" -exec chmod +x {} \;
````

## Contribution Guidelines

### Naming Conventions

- **Scripts**: Use kebab-case (e.g., `deploy-wordpress-site.sh`)
- **Workflows**: Use kebab-case (e.g., `run-tests.yml`)
- **Tests**: Use `test-` prefix (e.g., `test-deployment.bats`)
- **Dry-runs**: Use `dry-run-` prefix (e.g., `dry-run-deployment.sh`)

### Code Standards

#### Shell Scripts

- Use `#!/bin/bash` shebang
- Include `set -euo pipefail` for error handling
- Add header comments with script metadata
- Use meaningful variable names
- Include proper error handling and logging

#### Example Script Header

```bash
#!/bin/bash
#
# Script Name: script-name.sh
# Description: Brief description of what this script does
# Usage: ./script-name.sh [options] [arguments]
# Author: Your Name
# Date: YYYY-MM-DD
#

set -euo pipefail
```

#### GitHub Workflows

- Use meaningful job and step names
- Make workflows reusable with `workflow_call`
- Document all inputs and secrets
- Include proper error handling

### Testing Requirements

#### All Scripts Must Have Tests

- Create corresponding `.bats` test files
- Test both success and failure scenarios
- Include dry-run validation where applicable
- Test edge cases and error conditions

#### Running Tests

```bash
# Run all tests
bats tests/

# Run specific test
bats tests/test-script-name.bats

# Run dry-run validations
./tests/dry-run-script-name.sh
```

### Documentation

#### Required Documentation

- Update README.md if adding new directories
- Document script usage in header comments
- Add examples in relevant README files
- Update this CONTRIBUTING.md if changing processes

#### Code Comments

- Comment complex logic and decisions
- Explain why, not just what
- Keep comments up-to-date with code changes

### Pull Request Process

1. **Create descriptive PR title**: Use conventional commit format
    - `feat: add deployment automation script`
    - `fix: resolve logging issue in utility functions`
    - `docs: update workflow usage examples`

2. **Fill out PR template**: Complete all sections of the pull request template

3. **Ensure all checks pass**:
    - [ ] All Bats tests pass
    - [ ] Scripts follow naming conventions
    - [ ] Documentation updated
    - [ ] No new linting errors
    - [ ] All Markdown files pass linting (`markdownlint` status check is required for merge)

4. **Request review**: Assign appropriate reviewers

5. **Address feedback**: Make requested changes promptly

### Directory Structure Rules

```text
├── scripts/           # Shell scripts (kebab-case naming)
├── workflows/         # GitHub Actions workflows
├── tests/            # Bats tests and dry-run scripts
├── .github/          # GitHub templates and MCP config
└── logs/             # Log files (ignored in git)
```

#### Adding New Scripts

1. Place in appropriate `scripts/` subdirectory or root
2. Follow naming convention (kebab-case)
3. Include proper script header
4. Add corresponding test file
5. Update relevant README if needed

#### Adding New Workflows

1. Place in `workflows/` directory
2. Make reusable with `workflow_call` trigger
3. Document inputs and secrets
4. Test with sample repositories

### Code Review Guidelines

#### For Contributors

- Self-review your changes before submitting
- Test all changes thoroughly
- Keep changes focused and atomic
- Write clear commit messages

#### For Reviewers

- Check for adherence to conventions
- Verify tests are comprehensive
- Test workflows/scripts locally when possible
- Provide constructive feedback

### Getting Help

- Create an issue for questions or discussions
- Use appropriate issue templates
- Tag relevant maintainers if needed
- Check existing issues before creating new ones

### Teardown Instructions for Contributor Recognition Automation

If you need to remove contributor automation from this repository, follow these steps:

1. **Remove a Contributor**
    - Edit `.all-contributorsrc` and remove the contributor's entry from the `contributors` array.
    - Run:
        ```bash
        npx all-contributors generate
        ```
    - Commit and push the updated README and `.all-contributorsrc`.

2. **Disable Contributor Update Workflow**
    - Delete `.github/workflows/all-contributors-update.yml`.
    - Commit and push the change to remove the workflow.

3. **Remove CLI Dependency**
    - Uninstall the CLI tool:
        ```bash
        npm uninstall --save-dev all-contributors-cli
        ```
    - Remove any related documentation from README and `.all-contributorsrc-docs.md` if desired.

4. **Clean Up Files**
    - Optionally delete `.all-contributorsrc` and `.all-contributorsrc-docs.md` if contributor automation is no longer needed.

---

Thank you for contributing to LightSpeed WP automation! 🚀
