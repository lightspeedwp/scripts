# Shell Script Copilot Instructions

You are a shell script developer. Follow our LightSpeed WP Bash standards and testing practices to create and maintain automation scripts. Avoid complex dependencies, non-POSIX features, or undocumented options unless specified.

## Core Principles

### Error Handling

Always include proper error handling:

```bash
# Strict mode
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Script Structure

Follow this standard structure. All required header fields must be present and in the order shown below:

```bash
#!/bin/bash
# ============================================================================
# Script Name: kebab-case-name.sh
# Description: Clear description of functionality
# Version: v1.0.0
# Date: YYYY-MM-DD
# Author: LightSpeed WP Team
# Github Contributors: ...
# Author URI: ...
# License: ...
# License URI: ...
# Requirements: List any external tools required
# Usage: ./script-name.sh [options] [arguments]
# Environment Variables: ...
# Options: ...
# Examples: ...
# Notes: ...
# ============================================================================

# Strict mode
set -euo pipefail # Exit on error, undefined vars, pipe failures
```

- The header block must be the absolute first content in the file—no exceptions. No code, comments, blank lines, or documentation may appear above the header.
- Frame the header with a single block of `# ============================================================================` at the top and bottom.
    - Always use plural forms for "Notes" and "Examples" in headers, even if only one item is present (see Additional Guidance).
- If a header field is duplicated or outdated, merge and update for completeness.
- Directly below the header, place strict mode: `set -euo pipefail` (highlighted: **MANDATORY**).

### Variable Handling

- Use `readonly` for constants
- Quote all variables: `"${variable}"`
- Use descriptive names: `deployment_target` not `dt`
- Validate required parameters early

### Logging and Output

For required log format, error handling, and additional logging patterns, see [shell-script-header-and-docs.md](./shell-script-header-and-docs.md).

```bash
# ============================================================================
# Function: log_info
# Description: Log informational messages to stdout and log file
# Arguments: $* (message)
# Output: Writes to stdout and log file
# Notes: ...
# ============================================================================
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE"
}

# ============================================================================
# Function: log_error
# Description: Log error messages to stderr and log file
# Arguments: $* (message)
# Output: Writes to stderr and log file
# Notes: ...
# ============================================================================
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE" >&2
}
```

## Testing Requirements

### Bats Test Structure

Every script must have a corresponding Bats test file that follows these standards. No script may be merged without a corresponding test file.

```bash
#!/usr/bin/env bats
# ============================================================================
# Test name: test-script-name.bats
# Testing: script-name.sh
# Description: ...
# Version: ...
# Date: ...
# Author: ...
# ...etc...
# ============================================================================
# Load test helpers
load "$(dirname "$BATS_TEST_FILENAME")/../test-helper.bash"
```

### Dry Run Implementation

Include dry-run capability for destructive operations:

```bash
DRY_RUN=${DRY_RUN:-false}

# ============================================================================
# Function: execute_command
# Description: Execute or simulate a command based on DRY_RUN
# Arguments: $1 (command string)
# Output: Executes or logs command
# Notes: ...
# ============================================================================
execute_command() {
    local cmd="$1"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would execute: $cmd"
    else
        log_info "Executing: $cmd"
        eval "$cmd"
    fi
}
```

## Common Patterns

### Parameter Processing

All CLI options must be documented in the header and help output.

```bash
# ============================================================================
# Function: parse_arguments
# Description: Parse CLI arguments and set script options
# Arguments: "$@"
# Output: Sets global option variables
# Notes: ...
# ============================================================================
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}
```

### File Operations

```bash
# ============================================================================
# Function: backup_file
# Description: Backup a file to the backups directory
# Arguments: $1 (file path)
# Output: Creates backup file
# Notes: ...
# ============================================================================
backup_file() {
    local file="$1"
    local backup_dir="${SCRIPT_DIR}/backups"

    [[ ! -f "$file" ]] && { log_error "File not found: $file"; return 1; }

    mkdir -p "$backup_dir"
    cp "$file" "${backup_dir}/$(basename "$file").$(date +%s).backup"
    log_info "Backed up $file"
}
```

### GitHub API Integration

```bash
# ============================================================================
# Function: github_api_call
# Description: Call GitHub API endpoint
# Arguments: $1 (endpoint), $2 (method)
# Output: API response
# Notes: Requires GITHUB_TOKEN
# ============================================================================
github_api_call() {
    local endpoint="$1"
    local method="${2:-GET}"

    if [[ -z "$GITHUB_TOKEN" ]]; then
        log_error "GITHUB_TOKEN environment variable required"
        return 1
    fi

    curl -s -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         -X "$method" \
         "https://api.github.com/$endpoint"
}
```

## Security Guidelines

### Secrets Handling

- Never hardcode tokens or passwords
- Use environment variables with validation:

```bash
# ============================================================================
# Function: validate_environment
# Description: Validate required environment variables
# Arguments: None
# Output: Returns 1 if missing
# Notes: ...
# ============================================================================
validate_environment() {
    local required_vars=("GITHUB_TOKEN" "ORG_NAME")

    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            log_error "Required environment variable not set: $var"
            return 1
        fi
    done
}
```

### Input Validation

```bash
# ============================================================================
# Function: validate_input
# Description: Validate and sanitize input string
# Arguments: $1 (input)
# Output: Returns 1 if invalid
# Notes: ...
# ============================================================================
validate_input() {
    local input="$1"

    # Sanitize input
    if [[ ! "$input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid input format: $input"
        return 1
    fi
}
```

## Performance Considerations

- Use built-in commands over external tools when possible
- Implement progress indicators for long-running operations (see best practices in org docs)
- Use background jobs sparingly and always wait for completion
- Cache expensive operations when appropriate

## Integration with LightSpeed Workflow

### Branch Operations

```bash
# ============================================================================
# Function: create_feature_branch
# Description: Create a new feature branch with validated name
# Arguments: $1 (branch name)
# Output: Checks out new branch
# Notes: ...
# ============================================================================
create_feature_branch() {
    local branch_name="$1"

    # Validate branch naming convention
    if [[ ! "$branch_name" =~ ^(feature|fix|docs|chore)/.+ ]]; then
        log_error "Branch name must follow pattern: type/description"
        return 1
    fi

    git checkout -b "$branch_name"
}
```

### Automated Testing Integration

- Scripts should be testable in CI/CD pipelines
- Include exit codes that reflect success/failure clearly
- Generate test reports in standard formats when possible

---

## Header and Inline Documentation Placement (MANDATORY)

- The script header block MUST be the very first content in the file. No code, comments, blank lines, or documentation may appear above the header. This is **MANDATORY**.
- The header must include all required fields (see Script Structure above).
- Immediately after the header, place the strict mode line: `set -euo pipefail` (**MANDATORY**).
- Example:

    ```bash
    # ============================================================================
    # Script Name: example-script.sh
    # ... (all header fields) ...
    # ============================================================================
    set -euo pipefail
    # ...rest of code...
    ```

- Inline function documentation MUST be placed directly above the function definition it describes. Never place function documentation above the header block. Never insert any code, comments, or documentation before the header block.
- Example:

    ```bash
    # ============================================================================
    # Function: my_function
    # Description: ...
    # Arguments: ...
    # Output: ...
    # Notes: ...
    # ============================================================================
    my_function() {
        # ...function code...
    }
    ```

- When updating or adding documentation: If documentation exists, merge and update for completeness—never duplicate or abbreviate. Merge and expand function documentation only above the relevant function. Do not duplicate or move documentation above the header block. The header block must remain the first content in the file, followed by strict mode, then code and function docs.

- When adding new functions: Always add the inline documentation block immediately above the new function. Never add documentation for a new function above the header block.

- When refactoring or patching: If you find documentation above the header block, move it below the header and strict mode, above the relevant function. If you find multiple header blocks, merge them into a single block at the top of the file. Never place any code, comments, or sourcing above the header block.

- **Summary:**
    - The header block is always first (**MANDATORY**).
    - Strict mode is always second (**MANDATORY**).
    - Inline function documentation is always directly above the function it describes, never above the header (**MANDATORY**).
    - No code, comments, or documentation may appear before the header block (**MANDATORY**).
    - This is mandatory for all LightSpeed WP shell scripts.

---

## Additional Guidance

- Always use plural forms for "Notes" and "Examples" in headers, even if only one item is present.
- If a header field is duplicated or outdated, merge and update for completeness.
- If technical jargon is required, provide a brief explanation or link to a glossary. Example glossary entry:
    - **Strict mode**: Bash setting (`set -euo pipefail`) that enforces error handling and variable safety.
- Legacy or auto-generated scripts must be updated to conform to these standards before merging. Update process:
    1. Merge all header blocks into a single block at the top.
    2. Move any documentation above the header to below the header and strict mode, above the relevant function.
    3. Ensure all required header fields and strict mode are present and in correct order.
    4. Add or update inline documentation for all functions.
- Automation agents must:
    - Run markdown lint and header checks before merging.
    - Merge, deduplicate, and expand documentation blocks according to these standards.
    - Ensure legacy scripts are updated per the process above.
- For logging standards and more examples, see [shell-script-header-and-docs.md](./shell-script-header-and-docs.md).

---

Follow these instructions for all shell scripts in the repository to ensure documentation is complete, consistent, and maintainable. For further details, see [bats-tests-and-runner-scripts.md](./bats-tests-and-runner-scripts.md) and [shell-script-header-and-docs.md](./shell-script-header-and-docs.md). For further details, see [custom-instructions.md](../custom-instructions.md).
