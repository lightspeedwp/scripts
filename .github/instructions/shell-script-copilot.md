# Shell Script Copilot Instructions

You are a shell script developer working on LightSpeed WP automation. Follow our Bash standards and testing practices to create robust, maintainable scripts. Avoid complex dependencies and non-POSIX features unless specified.

## Core Principles

### Error Handling
Always include proper error handling:
```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Script Structure
Follow this standard structure:
```bash
#!/bin/bash
#
# Script Name: kebab-case-name.sh
# Description: Clear description of functionality
# Usage: ./script-name.sh [options] [arguments]  
# Dependencies: List any external tools required
# Author: LightSpeed WP Team
# Date: YYYY-MM-DD
#

set -euo pipefail

# Global variables (uppercase, descriptive names)
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/logs/$(basename "$0" .sh).log"

# Functions (lowercase with underscores)
function main() {
    # Script logic here
}

function cleanup() {
    # Cleanup logic
}

# Trap for cleanup
trap cleanup EXIT

# Call main function
main "$@"
```

### Variable Handling
- Use `readonly` for constants
- Quote all variables: `"${variable}"`
- Use descriptive names: `deployment_target` not `dt`
- Validate required parameters early

### Logging and Output
```bash
function log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE"
}

function log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE" >&2
}
```

## Testing Requirements

### Bats Test Structure
Every script must have a corresponding test file:
```bash
# tests/test-script-name.bats
#!/usr/bin/env bats

load test_helper

@test "script exists and is executable" {
    [ -x "${BATS_TEST_DIRNAME}/../scripts/script-name.sh" ]
}

@test "script shows help with --help flag" {
    run "${BATS_TEST_DIRNAME}/../scripts/script-name.sh" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "script handles missing parameters gracefully" {
    run "${BATS_TEST_DIRNAME}/../scripts/script-name.sh"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error:" ]]
}
```

### Dry Run Implementation
Include dry-run capability for destructive operations:
```bash
DRY_RUN=${DRY_RUN:-false}

function execute_command() {
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
```bash
function parse_arguments() {
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
function backup_file() {
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
function github_api_call() {
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
function validate_environment() {
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
function validate_input() {
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
- Implement progress indicators for long-running operations
- Use background jobs sparingly and always wait for completion
- Cache expensive operations when appropriate

## Integration with LightSpeed Workflow

### Branch Operations
```bash
function create_feature_branch() {
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