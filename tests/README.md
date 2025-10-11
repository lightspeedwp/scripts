
# Tests Directory

This directory contains test harnesses using Bats (Bash Automated Testing System) and dry-run scripts for validation.
 [![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
 [![Build Status](https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml)
 [![Playwright Tests](https://github.com/lightspeedwp/scripts/actions/workflows/playwright.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/playwright.yml)
 [![Lint Status](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml)

## CodeRabbit Review Automation

All tests in this directory are reviewed automatically by CodeRabbit for:
- Comprehensive coverage of scripts and automation features
- Error handling and edge case testing
- Integration with CI workflows and status checks
- Alignment with repo governance and merge requirements

See [.coderabbit.yml](../.coderabbit.yml) for full review rules.

This directory contains test harnesses using Bats (Bash Automated Testing System) and dry-run scripts for validation.

## Prerequisites

Install Bats testing framework:

```bash
# Ubuntu/Debian
sudo apt-get install bats

# macOS with Homebrew
brew install bats-core

# Manual installation
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

## Running Tests

```bash
# Run all tests
bats tests/

# Run specific test file
bats tests/test-example-deployment.bats

# Run tests with verbose output
bats -v tests/

# Run tests and generate TAP output
bats --tap tests/
```

## Test Structure

### Test Files

- Use `test-` prefix followed by the script name being tested
- Example: `test-example-deployment.bats` for testing `example-deployment.sh`
- Use `.bats` extension for Bats test files

### Dry-run Scripts

- Scripts that validate configuration without making changes
- Use `dry-run-` prefix (e.g., `scripts/dry-run-deployment.sh`)
- Should output what would be done without actually doing it

## Writing Tests

### Basic Test Structure

```bash
#!/usr/bin/env bats

# Setup function runs before each test
setup() {
    # Load the script to test
    load 'test-helper'
    source "${BATS_TEST_DIRNAME}/../scripts/script-name.sh"
}

# Teardown function runs after each test
teardown() {
    # Cleanup temporary files
    rm -f /tmp/test-*
}

@test "test description" {
    # Test implementation
    run command_to_test
    [ "$status" -eq 0 ]
    [[ "$output" =~ "expected output" ]]
}
```

### Playwright Test Structure

Playwright tests use the `@playwright/test` framework:

```typescript
import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveTitle(/Example Domain/);
});
```

See `tests/example.spec.ts` for a working example.

#### Running Playwright Tests

- Run all browser tests:

```bash
npx playwright test
```

- Run a specific test file:

```bash
npx playwright test tests/example.spec.ts
```

Playwright configuration and output are ignored via `.gitignore`.

See [Playwright documentation](https://playwright.dev/docs/intro) for more details.

### Best Practices

1. Test both success and failure scenarios
2. Use descriptive test names
3. Clean up temporary files in teardown
4. Mock external dependencies when possible
5. Test edge cases and error conditions

## Test Categories

### Unit Tests

Test individual functions and script components in isolation.

### Integration Tests

Test complete script workflows and interactions between components.

### Validation Tests

Dry-run tests that validate configuration and setup without making changes.

## Helper Functions

Common testing utilities are available in `test-helper.bash` for reuse across test files.

## Release Automation & Changelog Management
\n## Changelog Automation & Governance

Changelog entries are required for all PRs and are enforced by CodeRabbit and CI workflows. Automated release processes generate and update changelogs from commit history, with manual fallback as needed.

### Automated Release Process

Releases are automated when changes are merged from `develop` to `main`:

- On push to `main`, the release workflow:
    - Generates/updates `CHANGELOG.md` from commit history
    - Bumps version and tags the release
    - Publishes a GitHub Release with changelog details
    - All PRs must include a changelog entry in the required format (see PR template)

See `.github/workflows/release.yml` for details.

### Changelog Management Strategy

- All notable changes are documented in `CHANGELOG.md` using [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
- PRs must include a changelog entry in the following format:

```md
### Added
- Short description of new features or scripts

### Changed
- Short description of changes or improvements

### Fixed
- Short description of bug fixes

### Security
- Short description of security updates
```

- Changelog entries are required for all PRs and are included in the automated release process
- The PR template enforces changelog entry format and references automation

### Manual Release Fallback

If automation fails, releases can be created manually:

1. Update `CHANGELOG.md` with the latest changes
2. Bump the version in relevant files
3. Commit and tag the release:

```bash
git add CHANGELOG.md
git commit -m "chore(release): vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin main --tags
```

1. Create a GitHub Release and paste the changelog entry

### Reference

See [CHANGELOG.md](../CHANGELOG.md) and [release workflow](../.github/workflows/release.yml) for implementation details.
