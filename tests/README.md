# Tests Directory

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
- Use `dry-run-` prefix (e.g., `dry-run-deployment.sh`)
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