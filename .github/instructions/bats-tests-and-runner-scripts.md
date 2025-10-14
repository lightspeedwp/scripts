# Bats Tests and Runner Scripts Instructions

You are a shell script developer and test author. Follow our LightSpeed WP shell script and Bats testing framework to create robust, maintainable runner scripts and comprehensive test suites. Avoid non-standard naming, undocumented options, and inconsistent directory structures unless explicitly specified.

## Directory and Naming Conventions

- All runner scripts must use kebab-case naming (e.g., `run-utility-tests.sh`).
- Place runner scripts in `/scripts/{domain}/` (e.g., `/scripts/utility/`).
- Place Bats test files in `/tests/{domain}/` (e.g., `/tests/utility/`).
- Each domain must have a `README.md` describing runner/test process and conventions.
- The `/tests` folder must include `TEST_COVERAGE_SUMMARY.md` and `test-helper.bash`.

## Shell Script Header and Documentation

- Every runner script must follow the header and inline documentation standards in `shell-script-header-and-docs.md`.
- Document all options, environment variables, usage patterns, examples, and notes.
- Frame the header with `###############################################################################`.

## Runner Script Structure

- Use strict mode: `set -euo pipefail`.
- Directory setup:

  ```sh
  SCRIPT_DIR="$(cd \"$(dirname \"${BASH_SOURCE[0]}\")" && pwd)"
  REPO_ROOT="$(cd \"$SCRIPT_DIR/../..\" && pwd)"
  ```

- Test directory: `TEST_DIR="$REPO_ROOT/tests/{domain}"`
- Log files: Store in `$SCRIPT_DIR/logs/` or `$REPO_ROOT/logs/` (document format and location in header).
- Logging functions must prefix output with `[INFO]`, `[SUCCESS]`, `[ERROR]` and support color.

## Runner Script Options (Maximum Set)

- `--help`           Show help message
- `--verbose`        Show detailed output
- `--quiet`          Show minimal output
- `--list`           List all available test files
- `--test <name>`    Run a specific test file by name (without `.bats`)
- `--color`          Enable colored output
- `--no-color`       Disable colored output
- `--log-file <file>` Specify log file
- `--timeout <sec>`  Set timeout for each test
- `--parallel <n>`   Run tests in parallel
- `--filter <pat>`   Run tests matching pattern
- `--exclude <pat>`  Exclude tests matching pattern
- `--retry <n>`      Retry failed tests
- `--coverage`       Generate coverage report
- `--junit <file>`   Output JUnit XML
- `--tap <file>`     Output TAP format
- `--html <file>`    Output HTML format
- `--json <file>`    Output JSON format
- `--summary`        Show summary
- `--detailed`       Show detailed output
- `--list-tests`     List all individual tests
- `--list-suites`    List all test suites
- `--list-tags`      List all tags
- `--tag <tag>`      Run tests with tag
- `--exclude-tag <tag>` Exclude tests with tag
- `--help-test`      Show help for test options
- `--help-general`   Show help for general options
- `--version`        Show script version
- `--update`         Update runner script
- `--install-deps`   Install dependencies
- `--check-deps`     Check dependencies
- `--dry-run`        Show what would be done
- `--force`          Force execution
- `--skip`           Skip tests/checks
- `--only`           Run only specified tests
- `--config <file>`  Specify config file
- `--env <key=val>`  Set environment variable
- `--list-env`       List environment variables
- `--clear-env`      Clear environment variables
- `--help-all`       Show help for all options

## Bats Test File Standards

This section outlines the comprehensive standards for creating and documenting Bats test files. Adhering to these standards is crucial for maintainability, readability, and consistency across the repository.

### Naming and Location

- **File Naming**: Use kebab-case for all test file names (e.g., `test-run-utility-tests.bats`).
- **File Location**: Place test files in the corresponding domain folder under `/tests/` (e.g., `/tests/utility/`).

### Test File Header

Every Bats test file **must** begin with a standardized header block immediately following the `#!/usr/bin/env bats` shebang. This header provides essential metadata about the test suite.

**Header Format:**

- The entire header block must be enclosed by comment dividers.
- It must contain a comprehensive set of metadata fields.

**Example Header:**

```bats
#!/usr/bin/env bats
# ============================================================================
# Test name: test-validate-release.bats
# Testing: validate-release.sh script
# Description: A brief summary of the test suite's purpose.
# Version: v1.0.0
# Date: YYYY-MM-DD
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Github Author: @github-username
# Requirements:
#   - bats-core         # The testing framework
#   - test-helper.bash  # Shared test helpers
# Usage:
#   - bats path/to/test-file.bats    # How to run the test suite directly
# Options:
#  - None             # List any command-line options the test script itself might parse
# Test Scope:
#   - A detailed outline of what is and is not being tested by this file.
# ============================================================================

# Load test helpers
load '../test-helper.bash'
```

### Section Headers

To improve readability, group related tests into sections using a standardized section header format.

**Section Header Format:**

```bats
# ----- Section: A Clear and Descriptive Section Title -----
```

**Example:**

```bats
# ----- Section: Setup and Teardown functions -----

# ... setup() and teardown() functions ...

# ----- Section: Help and Usage Tests -----

@test "script responds to --help flag" {
  # ... test implementation ...
}
```

### Test Function Inline Documentation

Every function, including `setup()`, `teardown()`, and each `@test`, **must** have a documentation block immediately preceding it. This block explains the purpose and scope of the specific test or function.

**Inline Documentation Format:**

- The block must be enclosed by comment dividers.
- It should detail the type and scope of the test.

**Recommended Fields:**

- **Test Name**: The name of the test function as a string (e.g., `"script responds to --help flag"`).
- **Test Type**: The category of the test (e.g., `Basic Validation`, `Argument Parsing`, `Error Handling`).
- **Test Scope**: A concise description of what the specific test validates (e.g., `Ensures the --help flag returns a zero exit code and displays usage info.`).

**Example:**

```bats
# ============================================================================
# Test Name: "script responds to --help flag"
# Test Type: Help and Usage
# Test Scope: Validates that the script exits with status 0 and outputs a usage message when the --help flag is provided.
# ============================================================================
@test "script responds to --help flag" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage"* ]]
}
```

### General Rules and Best Practices

#### Do

- **Follow the Structure**: Always include the File Header, Section Headers, and Test Function Documentation in every test file.
- **Be Descriptive**: Write clear, concise descriptions for test scopes and names.
- **Group Related Tests**: Use Section Headers to logically organize your tests.
- **Load the Helper**: Start your script body by loading the `test-helper.bash` file.
- **Resolve Paths Correctly**: Use the `setup()` function to define paths to the scripts being tested, ensuring they are relative to the test file's location.

  ```sh
  setup() {
      DIR="$( cd \"$( dirname \"$BATS_TEST_FILENAME\" )" >/dev/null 2>&1 && pwd )"
      SCRIPT_UNDER_TEST="$DIR/../../scripts/{domain}/your-script.sh"
      [ -f "$SCRIPT_UNDER_TEST" ]
      [ -x "$SCRIPT_UNDER_TEST" ]
  }
  ```

#### Don't

- **Never Strip Headers or Comments**: Automated processes or manual edits should **never** remove file headers, section headers, or function documentation blocks. They are essential for maintainability.
- **Avoid Vague Descriptions**: Do not use generic or unhelpful descriptions in your documentation.
- **Don't Hardcode Paths**: Avoid hardcoding absolute paths. Always use relative paths from the test file's location (`$BATS_TEST_FILENAME`).## test-helper.bash Requirements

- Provide shared functions for path resolution, output normalization, and environment setup.
- Document all helper functions with header blocks as per shell-script-header-and-docs.md.
- Place in `/tests/` and load in every test file.

## README.md Requirements

- `/tests/README.md` must describe:
  - Test runner process
  - Directory structure
  - How to run all tests and individual tests
  - Coverage summary and reporting
  - How to use `test-helper.bash`
- `/scripts/{domain}/README.md` must describe:
  - Runner script usage and options
  - Logging and output conventions
  - Directory and path setup
  - How to add new runner scripts and tests

## Coverage Summary

- Maintain `TEST_COVERAGE_SUMMARY.md` in `/tests/`.
- List all runner scripts and test files, with coverage status and notes.

## Logging and Output

- All runner scripts must log to both stdout and log files.
- Log files must be stored in a `logs/` subfolder and documented in the script header.
- Log format: `[LEVEL] YYYY-MM-DD HH:MM:SS: message`
- All errors must be logged and returned with non-zero exit status.

## Reference

- Always follow the standards in `shell-script-header-and-docs.md` for all documentation and function comments.

---

## How to Run Test Runner Scripts and Bats Tests

### Direct Usage

- To run all tests for a domain:
  ```sh
  ./scripts/{domain}/run-{domain}-tests.sh
  ```
- To run a specific test file:
  ```sh
  ./scripts/{domain}/run-{domain}-tests.sh --test <test-file-name>
  ```
- To list available test files:
  ```sh
  ./scripts/{domain}/run-{domain}-tests.sh --list
  ```
- To run with verbose output:
  ```sh
  ./scripts/{domain}/run-{domain}-tests.sh --verbose
  ```
- To run in dry-run mode:
  ```sh
  ./scripts/{domain}/run-{domain}-tests.sh --dry-run
  ```
- To run all Bats tests directly:
  ```sh
  npx bats tests/{domain}/
  ```

### Using Copilot for Test Execution and Validation

- Instruct Copilot to:
  - Run all runner scripts and Bats test suites for each domain
  - Report and fix any errors in test output or runner script execution
  - Identify missing options, error handling, or documentation in runner scripts and test files
  - Validate that all required options and logging conventions are implemented
  - Ensure coverage summary and README files are up to date

#### Example Copilot Prompt Template

If you want reusable prompt templates for Copilot automation or review, create a file in `.github/prompts/` (e.g., `test-runner-prompts.md`) with patterns like:

```text
Run all test runner scripts and Bats test suites for {domain}. Report any errors, missing functionality, or documentation gaps. Fix issues and validate coverage.
```

---

Follow these instructions for all runner scripts and Bats test files in the repository to ensure maintainability, coverage, and documentation quality.
