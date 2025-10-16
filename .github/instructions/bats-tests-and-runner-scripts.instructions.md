---
applyTo: '**/*'
description: 'Shell script and Bats test standards for LightSpeed WP'
version: '0.1.0'
author: 'LightSpeed WP Team'
audience: ['contributor', 'maintainer', 'reviewer', 'automation']
status: 'approved'
changelog: ['2025-10-15: Initial version', '2025-10-15: Added extended fields for governance']
tags: ['standards', 'shell', 'bats', 'testing']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
deprecated: false
related: ['custom-instructions.md', 'AGENTS.md', 'prompts.md', 'chatmodes.md']
updated: '2025-10-15'
created: '2025-10-15'
---

You are a shell script developer and test author. Follow our LightSpeed WP documentation, scripting, and testing standards to create and maintain shell scripts, runner scripts, and Bats test suites. Avoid truncating, duplicating, omitting header fields, missing inline documentation, non-POSIX features, complex dependencies, or undocumented options unless specified.
...existing code...

You are a shell script developer and test author. Follow our LightSpeed WP documentation, scripting, and testing standards to create and maintain shell scripts, runner scripts, and Bats test suites. Avoid truncating, duplicating, omitting header fields, missing inline documentation, non-POSIX features, complex dependencies, or undocumented options unless specified.

**Strictly preserve all original content, context, and examples when refactoring or updating instruction files. Do not strip out, abbreviate, or remove any information unless explicitly directed. All merges and updates must be traceable and maintain full historical context.**

## Purpose and Scope
Covers header and inline documentation standards, runner script structure, Bats test file standards, directory/naming conventions, logging, output, coverage, and CI/CD integration.

## Core Principles
- Clarity, maintainability, and testability
- Actionable, testable code
- Consistent structure and documentation
- Integration with org-wide standards

## Required Sections
- Role definition and context
- Framework and standards to follow
- Task types and scenarios
- Anti-patterns and explicit exclusions
- Examples and references

## Formatting Guidelines
- Use markdown headings and bullet lists
- Include code blocks for templates and examples
- Reference related files using relative links

## Integration References
- See `.github/custom-instructions.md` and related agent, prompt, and chatmode files

## Review and Enforcement
- Use the checklist in `create-or-update-copilot.instructions.md` to validate clarity, completeness, and compliance

# LightSpeed WP Shell Script and Bats Test Standards

## Introduction

This document merges all LightSpeed WP instructions for shell scripts, runner scripts, and Bats test files. It covers:

- Header and inline documentation standards for shell scripts and helper functions
- Structure and conventions for runner scripts
- Bats test file standards, including headers, sectioning, and inline documentation
- Directory, naming, and loader conventions
- Logging, output, and coverage requirements
- Best practices for maintainability, clarity, and CI/CD integration

Use this as the single source of truth for all scripting and testing in the repository.

---
---

## Directory and Naming Conventions

  - See the **Test Helper File** and **Loader Scenarios** sections below for full details and best practices on loader usage, including variable-based and dynamic path resolution.
  - Always include the inline documentation note `# Load test helpers` above the loader line.

- **Coverage summary**: `/tests/TEST_COVERAGE_SUMMARY.md` must list all runner scripts and test files, with coverage status and notes.

---

## Shell Script Header and Inline Documentation Standards

- **Header block must be the very first content in the file.**

  - No code, comments, blank lines, or documentation may appear above the header.
  - Frame the header with `# ============================================================================` at the top and bottom.
  - Include all required fields, in order (see below).
  - Directly below the header, place strict mode: `set -euo pipefail`.

- **Header fields (merge from both standards):**

  - Script Name
  - Description (detailed, single paragraph)
  - Version
  - Author
  - Github Contributors
  - Author URI
  - License
  - License URI
  - Requirements (all dependencies, tools, and setup steps)
  - Usage (all invocation patterns, including environment variables)
  - Environment Variables (all possible, with descriptions)
  - Options (all CLI flags and arguments, with descriptions)
  - Examples (all relevant, covering every option and environment variable)
  - Notes (plural, all important operational, troubleshooting, and idempotency notes)

- **Inline function documentation:**

  You are a shell script developer and test author. Follow our LightSpeed WP documentation, scripting, and testing standards to create and maintain shell scripts, runner scripts, and Bats test suites. Avoid truncating, duplicating, omitting header fields, missing inline documentation, non-POSIX features, complex dependencies, or undocumented options unless specified.
    ```bash
    # Function: function_name
    # Description: ...
    # Arguments: ...
    # Output: ...
    # Notes: ...
    ```

  - If a function has no arguments or output, state "None".
  - Place documentation immediately above the function definition.
  - Do not duplicate or omit documentation. Merge and expand as needed.

- **General practices:**

  - Never delete, contract, or duplicate documentation.
  - Always expand and validate for completeness.
  - Use consistent formatting and indentation.
  - If multiple header blocks exist, merge into one at the top.
  - Never place any code, comments, or sourcing above the header block and strict mode.

---

## Runner Script Structure and Options

- Use strict mode: `set -euo pipefail`.
- Directory setup:

  ```sh
  SCRIPT_DIR="$(cd \"$(dirname \"${BASH_SOURCE[0]}\")" && pwd)"
  REPO_ROOT="$(cd \"$SCRIPT_DIR/../..\" && pwd)"
  TEST_DIR="$REPO_ROOT/tests/{domain}"
  ```

- Log files: Store in `$SCRIPT_DIR/logs/` or `$REPO_ROOT/logs/`. Document format and location in header.
- Logging functions must prefix output with `[INFO]`, `[SUCCESS]`, `[ERROR]` and support color.
- **Options**: Runner scripts should support a comprehensive set of CLI options (see below for full list). Document all options in the script header and help output.

---

## Runner Script CLI Options (Recommended Set)

- `--help`           Show help message
- `--verbose`        Show detailed output
- `--quiet`          Show minimal output
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
- `--check-deps`     Check dependencies
- `--dry-run`        Show what would be done
- `--force`          Force execution
- `--skip`           Skip tests/checks
- `--only`           Run only specified tests
- `--env <key=val>`  Set environment variable
- `--list-env`       List environment variables
- `--clear-env`      Clear environment variables
- `--help-all`       Show help for all options


## Bats Test File Standards
- Place test files in the corresponding domain folder under `/tests/`.
### Test File Header

- Every Bats test file must begin with a standardized header block immediately following the `#!/usr/bin/env bats` shebang.
- The header must provide essential metadata (see example below).


```bats
# Version: v1.0.0
# Author: LightSpeedWP
# Author URI: https://lightspeedwp.agency/
# Usage:
# Options:
#  - None             # List any command-line options the test script itself might parse


- The test helper must be loaded immediately below the header in every Bats test file.

  ```bats
  # Load test helpers
  load "$(dirname \"$BATS_TEST_FILENAME\")/../test-helper.bash"
  ```

#### Loader Scenarios

- **Test file in `/tests/` root:**

  ```bats
  # Load test helpers
  load "./test-helper.bash"
  ```

- **Test file in `/tests/{domain}/` subfolder:**

  ```bats
  # Load test helpers
  load "$(dirname \"$BATS_TEST_FILENAME\")/../test-helper.bash"
  ```
- **Test file in deeper nested folder (e.g., `/tests/{domain}/subdir/`):**

  - You may need to adjust the path, e.g.:

    ```bats
    # Load test helpers
    load "$(dirname \"$BATS_TEST_FILENAME\")/../../test-helper.bash"
    ```

  - Or use a search function or helper to locate the file dynamically.

#### Best Practice

- Prefer the variable-based loader for all test files unless you are certain the folder structure will never change.
- If you refactor or move test files, always verify the loader path resolves correctly.
- Never hardcode static relative paths unless required by project constraints.
- If in doubt, use:
  ```bats
  # Load test helpers
  ```
  and test with `bats` from the repo root and from the test folder.

### Section Headers

- Group related tests into sections using standardized section headers.

  ```bats
  # ----- Section: A Clear and Descriptive Section Title -----
  ```

### Test Function Inline Documentation

- Every function, including `setup()`, `teardown()`, and each `@test`, must have a documentation block immediately preceding it.
- The block should detail the test name, type, and scope.
- Frame the fest function inline documentation with `# ============================================================================` at the top and bottom.

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

---

## General Rules and Best Practices

### Do

- Always include the File Header, Section Headers, and Test Function Documentation in every test file.
- Write clear, concise descriptions for test scopes and names.
- Use Section Headers to logically organize your tests.
- Load `test-helper.bash` at the start of every test file using the correct relative path and inline documentation note.
- Use `setup()` to resolve paths to scripts under test, relative to the test file's location.
- Document all helper functions with header blocks as per the standards above.

### Don't

- Never remove file headers, section headers, or function documentation blocks.
- Avoid vague descriptions in documentation.
- Don't hardcode absolute paths; always use relative paths from `$BATS_TEST_FILENAME`.
- Do not truncate, remove, or abbreviate any header or function documentation.
- Do not duplicate header or function documentation.
- Do not use inconsistent formatting or omit required fields.
- Do not overwrite manual additions with automated content.
- Do not use technical jargon without explanation.

---

## test-helper.bash Requirements

- Provide shared functions for path resolution, output normalization, and environment setup.
- Document all helper functions with header blocks as per the standards above.
- Place in `/tests/` and load in every test file.

---

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

---

## Coverage Summary

- Maintain `TEST_COVERAGE_SUMMARY.md` in `/tests/`.
- List all runner scripts and test files, with coverage status and notes.

---

## Logging and Output

- All runner scripts must log to both stdout and log files.
- Log files must be stored in a `logs/` subfolder and documented in the script header.
- Log format: `[LEVEL] YYYY-MM-DD HH:MM:SS: message`
- All errors must be logged and returned with non-zero exit status.

---

## Reference

- Always follow the standards in this document for all documentation and function comments.

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

Follow these instructions for all shell scripts, runner scripts, and Bats test files in the repository to ensure maintainability, coverage, and documentation quality. For further details, see [custom-instructions.md](../custom-instructions.md).

<!-- End of Bats Tests and Runner Scripts Instructions -->
