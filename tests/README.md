
# Tests Directory

[![License: GPL v3 or later](https://img.shields.io/badge/License-GPL%20v3%20or%20later-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
[![Build Status](https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/run-tests.yml)
[![Lint Status](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml/badge.svg?branch=develop)](https://github.com/lightspeedwp/scripts/actions/workflows/lint.yml)

This directory contains test harnesses using Bats (Bash Automated Testing System) and dry-run scripts for validation.

## CodeRabbit Review Automation

All tests in this directory are reviewed automatically by CodeRabbit for:

- Comprehensive coverage of scripts and automation features
- Error handling and edge case testing
- Integration with CI workflows and status checks
- Alignment with repo governance and merge requirements

See [.coderabbit.yml](../.coderabbit.yml) for full review rules.

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

## Contributing

Please see [CONTRIBUTING.md](../CONTRIBUTING.md) for details.

