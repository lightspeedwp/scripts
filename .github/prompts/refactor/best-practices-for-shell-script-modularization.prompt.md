---
applyTo: '**'
description: 'Prompt for best practices in modular shell script development.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['modularization', 'shell', 'best-practices']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Best Practices for Shell Script Modularization

## Role

You are a shell script architecture specialist for automation systems. Follow our LightSpeed WP standards to design and implement comprehensive best practices for modular shell script development that promote maintainability, reusability, testability, and reliability across complex automation workflows.

## Purpose

Establish definitive best practices and architectural guidelines for modular shell script development that ensure consistent code quality, optimal performance, secure implementation, and seamless integration within enterprise automation environments while maintaining backward compatibility and extensibility.

## Checklist


## Current Repository State & Action Items


**Action:** Create missing includes, add Bats tests, expand documentation, and update folder names for consistency.
**Note:** As part of the refactor, `/scripts/project/` will be renamed to `/scripts/projects/` and `/tests/project-scripts/` to `/tests/projects/`. Update all references in scripts, tests, workflows, and documentation to match the new names and validate that automation works after changes.
- [ ] Create integration and deployment best practices

## Instructions

### Modularization Architecture Principles

#### Core Design Principles

##### 1. Single Responsibility Principle

```bash
#!/bin/bash
# scripts/includes/validation/input-validation.sh

# ============================================================================
# Script Name: input-validation.sh
# Description: Comprehensive input validation functions for shell scripts
# Usage: source scripts/includes/validation/input-validation.sh
# Examples:
#   # Basic validation
#   validate_required_param "$username" "username"
#   validate_email_format "$email"
#   validate_file_exists "$config_file"
#
#   # Complex validation with custom rules
#   validate_with_pattern "$input" "^[a-zA-Z0-9_-]+$" "alphanumeric with dashes"
#   validate_number_range "$port" 1 65535 "port number"
#
#   # Batch validation
#   validate_params_batch "username:$username" "email:$email" "port:$port"
# ============================================================================

set -euo pipefail

readonly VALIDATION_LOG_LEVEL="${VALIDATION_LOG_LEVEL:-INFO}"
readonly VALIDATION_STRICT_MODE="${VALIDATION_STRICT_MODE:-true}"

# Initialize validation state
declare -A VALIDATION_ERRORS=()
declare -i VALIDATION_ERROR_COUNT=0

validate_required_param() {
    local value="$1"
    local param_name="$2"
    local error_message="${3:-Parameter '$param_name' is required}"

    if [[ -z "${value:-}" ]]; then
        add_validation_error "$param_name" "$error_message"
        return 1
    fi

    log_validation_debug "Required parameter validation passed: $param_name"
    return 0
}

validate_email_format() {
    local email="$1"
    local param_name="${2:-email}"

    local email_pattern='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    if [[ ! "$email" =~ $email_pattern ]]; then
        add_validation_error "$param_name" "Invalid email format: $email"
        return 1
    fi

    log_validation_debug "Email format validation passed: $email"
    return 0
}

validate_file_exists() {
    local file_path="$1"
    local param_name="${2:-file_path}"
    local check_readable="${3:-false}"

    if [[ ! -f "$file_path" ]]; then
        add_validation_error "$param_name" "File does not exist: $file_path"
        return 1
    fi

    if [[ "$check_readable" == "true" && ! -r "$file_path" ]]; then
        add_validation_error "$param_name" "File is not readable: $file_path"
        return 1
    fi

    log_validation_debug "File existence validation passed: $file_path"
    return 0
}

validate_directory_exists() {
    local dir_path="$1"
    local param_name="${2:-directory_path}"
    local check_writable="${3:-false}"

    if [[ ! -d "$dir_path" ]]; then
        add_validation_error "$param_name" "Directory does not exist: $dir_path"
        return 1
    fi

    if [[ "$check_writable" == "true" && ! -w "$dir_path" ]]; then
        add_validation_error "$param_name" "Directory is not writable: $dir_path"
        return 1
    fi

    log_validation_debug "Directory validation passed: $dir_path"
    return 0
}

validate_with_pattern() {
    local value="$1"
    local pattern="$2"
    local description="$3"
    local param_name="${4:-value}"

    if [[ ! "$value" =~ $pattern ]]; then
        add_validation_error "$param_name" "Value does not match required pattern ($description): $value"
        return 1
    fi

    log_validation_debug "Pattern validation passed for $description: $value"
    return 0
}

validate_number_range() {
    local value="$1"
    local min_val="$2"
    local max_val="$3"
    local description="$4"
    local param_name="${5:-number}"

    # Check if value is a number
    if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
        add_validation_error "$param_name" "Value is not a valid number: $value"
        return 1
    fi

    # Check range
    if [[ $value -lt $min_val || $value -gt $max_val ]]; then
        add_validation_error "$param_name" "$description must be between $min_val and $max_val, got: $value"
        return 1
    fi

    log_validation_debug "Number range validation passed for $description: $value"
    return 0
}

validate_url_format() {
    local url="$1"
    local param_name="${2:-url}"
    local allowed_schemes="${3:-http https}"

    # Basic URL pattern
    local url_pattern='^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$'

    if [[ ! "$url" =~ $url_pattern ]]; then
        add_validation_error "$param_name" "Invalid URL format: $url"
        return 1
    fi

    # Validate scheme if specified
    if [[ -n "$allowed_schemes" ]]; then
        local scheme="${url%%://*}"
        if [[ ! " $allowed_schemes " =~ " $scheme " ]]; then
            add_validation_error "$param_name" "URL scheme '$scheme' not allowed. Allowed: $allowed_schemes"
            return 1
        fi
    fi

    log_validation_debug "URL format validation passed: $url"
    return 0
}

validate_params_batch() {
    local batch_errors=0
    local param_spec

    for param_spec in "$@"; do
        local param_name="${param_spec%%:*}"
        local param_value="${param_spec#*:}"

        case "$param_name" in
            *_email)
                validate_email_format "$param_value" "$param_name" || ((batch_errors++))
                ;;
            *_file)
                validate_file_exists "$param_value" "$param_name" || ((batch_errors++))
                ;;
            *_dir|*_directory)
                validate_directory_exists "$param_value" "$param_name" || ((batch_errors++))
                ;;
            *_url)
                validate_url_format "$param_value" "$param_name" || ((batch_errors++))
                ;;
            *)
                validate_required_param "$param_value" "$param_name" || ((batch_errors++))
                ;;
        esac
    done

    if [[ $batch_errors -gt 0 ]]; then
        log_validation_error "Batch validation failed with $batch_errors errors"
        return 1
    fi

    log_validation_info "Batch validation passed for ${#@} parameters"
    return 0
}

# Validation error management
add_validation_error() {
    local param_name="$1"
    local error_message="$2"

    VALIDATION_ERRORS["$param_name"]="$error_message"
    ((VALIDATION_ERROR_COUNT++))

    log_validation_error "Validation error for '$param_name': $error_message"

    if [[ "$VALIDATION_STRICT_MODE" == "true" ]]; then
        return 1
    fi
}

get_validation_errors() {
    local output_format="${1:-text}"

    if [[ $VALIDATION_ERROR_COUNT -eq 0 ]]; then
        echo "No validation errors"
        return 0
    fi

    case "$output_format" in
        "json")
            echo "{"
            echo "  \"error_count\": $VALIDATION_ERROR_COUNT,"
            echo "  \"errors\": {"
            local first=true
            for param in "${!VALIDATION_ERRORS[@]}"; do
                if [[ "$first" == "true" ]]; then
                    first=false
                else
                    echo ","
                fi
                echo -n "    \"$param\": \"${VALIDATION_ERRORS[$param]}\""
            done
            echo ""
            echo "  }"
            echo "}"
            ;;
        *)
            echo "Validation Errors ($VALIDATION_ERROR_COUNT):"
            for param in "${!VALIDATION_ERRORS[@]}"; do
                echo "  - $param: ${VALIDATION_ERRORS[$param]}"
            done
            ;;
    esac
}

clear_validation_errors() {
    VALIDATION_ERRORS=()
    VALIDATION_ERROR_COUNT=0
    log_validation_debug "Validation errors cleared"
}

# Validation logging functions
log_validation_debug() {
    [[ "$VALIDATION_LOG_LEVEL" == "DEBUG" ]] && echo "[VALIDATION DEBUG] $*" >&2
}

log_validation_info() {
    [[ "$VALIDATION_LOG_LEVEL" =~ ^(DEBUG|INFO)$ ]] && echo "[VALIDATION INFO] $*" >&2
}

log_validation_error() {
    echo "[VALIDATION ERROR] $*" >&2
}
```

##### 2. Interface Segregation and Dependency Management

```bash
#!/bin/bash
# scripts/includes/interfaces/github-interface.sh

# ============================================================================
# Script Name: github-interface.sh
# Description: Clean interface for GitHub API operations with dependency injection
# Usage: source scripts/includes/interfaces/github-interface.sh
# Examples:
#   # Configure API client
#   configure_github_client "https://api.github.com" "$GITHUB_TOKEN"
#
#   # Repository operations
#   github_get_repository "owner/repo"
#   github_create_repository "new-repo" "Repository description"
#
#   # Issue operations
#   github_create_issue "owner/repo" "Issue Title" "Issue description"
#   github_update_issue "owner/repo" 123 "Updated title"
#
#   # Label operations
#   github_sync_labels "owner/repo" "labels.json"
# ============================================================================

set -euo pipefail

# Interface dependencies (injected)
declare -A GITHUB_CONFIG=()
declare -A GITHUB_CLIENT_DEPENDENCIES=()

# Configure GitHub client with dependency injection
configure_github_client() {
    local api_base_url="$1"
    local auth_token="$2"
    local http_client="${3:-curl}"
    local json_processor="${4:-jq}"

    GITHUB_CONFIG[api_base_url]="$api_base_url"
    GITHUB_CONFIG[auth_token]="$auth_token"
    GITHUB_CONFIG[user_agent]="LightSpeed-WP-Scripts/1.0"

    GITHUB_CLIENT_DEPENDENCIES[http_client]="$http_client"
    GITHUB_CLIENT_DEPENDENCIES[json_processor]="$json_processor"

    # Validate dependencies
    validate_github_dependencies || return 1

    log_info "GitHub client configured for: $api_base_url"
}

validate_github_dependencies() {
    local http_client="${GITHUB_CLIENT_DEPENDENCIES[http_client]}"
    local json_processor="${GITHUB_CLIENT_DEPENDENCIES[json_processor]}"

    if ! command -v "$http_client" >/dev/null 2>&1; then
        log_error "HTTP client not found: $http_client"
        return 1
    fi

    if ! command -v "$json_processor" >/dev/null 2>&1; then
        log_error "JSON processor not found: $json_processor"
        return 1
    fi

    if [[ -z "${GITHUB_CONFIG[auth_token]:-}" ]]; then
        log_error "GitHub authentication token not configured"
        return 1
    fi

    return 0
}

# Repository interface operations
github_get_repository() {
    local repo_path="$1"
    local output_format="${2:-json}"

    local response=$(github_api_request "GET" "repos/$repo_path" "" "$output_format")
    local status=$?

    if [[ $status -eq 0 ]]; then
        echo "$response"
    else
        log_error "Failed to get repository: $repo_path"
        return 1
    fi
}

github_create_repository() {
    local repo_name="$1"
    local description="$2"
    local is_private="${3:-false}"
    local auto_init="${4:-true}"

    local payload=$(create_repository_payload "$repo_name" "$description" "$is_private" "$auto_init")
    local response=$(github_api_request "POST" "user/repos" "$payload" "json")
    local status=$?

    if [[ $status -eq 0 ]]; then
        log_success "Repository created: $repo_name"
        echo "$response"
    else
        log_error "Failed to create repository: $repo_name"
        return 1
    fi
}

github_list_repositories() {
    local org_name="${1:-}"
    local per_page="${2:-30}"
    local page="${3:-1}"

    local endpoint
    if [[ -n "$org_name" ]]; then
        endpoint="orgs/$org_name/repos"
    else
        endpoint="user/repos"
    fi

    local query_params="per_page=$per_page&page=$page&sort=updated"
    local response=$(github_api_request "GET" "$endpoint?$query_params" "" "json")

    echo "$response"
}

# Issue interface operations
github_create_issue() {
    local repo_path="$1"
    local title="$2"
    local body="$3"
    local labels="${4:-}"
    local assignees="${5:-}"

    local payload=$(create_issue_payload "$title" "$body" "$labels" "$assignees")
    local response=$(github_api_request "POST" "repos/$repo_path/issues" "$payload" "json")
    local status=$?

    if [[ $status -eq 0 ]]; then
        log_success "Issue created in $repo_path: $title"
        echo "$response"
    else
        log_error "Failed to create issue in $repo_path: $title"
        return 1
    fi
}

github_update_issue() {
    local repo_path="$1"
    local issue_number="$2"
    local title="${3:-}"
    local body="${4:-}"
    local state="${5:-}"
    local labels="${6:-}"

    local payload=$(create_issue_update_payload "$title" "$body" "$state" "$labels")
    local response=$(github_api_request "PATCH" "repos/$repo_path/issues/$issue_number" "$payload" "json")
    local status=$?

    if [[ $status -eq 0 ]]; then
        log_success "Issue updated in $repo_path: #$issue_number"
        echo "$response"
    else
        log_error "Failed to update issue in $repo_path: #$issue_number"
        return 1
    fi
}

# Label interface operations
github_sync_labels() {
    local repo_path="$1"
    local labels_config_file="$2"
    local dry_run="${3:-false}"

    log_info "Synchronizing labels for $repo_path"

    # Get current labels
    local current_labels=$(github_api_request "GET" "repos/$repo_path/labels" "" "json")

    # Get target labels from configuration
    local target_labels
    if ! target_labels=$(cat "$labels_config_file"); then
        log_error "Failed to read labels configuration: $labels_config_file"
        return 1
    fi

    # Process label synchronization
    sync_repository_labels "$repo_path" "$current_labels" "$target_labels" "$dry_run"
}

# Core API request function
github_api_request() {
    local method="$1"
    local endpoint="$2"
    local payload="$3"
    local response_format="${4:-json}"

    local http_client="${GITHUB_CLIENT_DEPENDENCIES[http_client]}"
    local api_url="${GITHUB_CONFIG[api_base_url]}/$endpoint"
    local auth_header="Authorization: token ${GITHUB_CONFIG[auth_token]}"
    local user_agent_header="User-Agent: ${GITHUB_CONFIG[user_agent]}"

    local temp_response="/tmp/github_response_$$"
    local temp_headers="/tmp/github_headers_$$"

    # Build curl command
    local curl_args=(
        -s
        -w "%{http_code}"
        -H "$auth_header"
        -H "$user_agent_header"
        -H "Accept: application/vnd.github.v3+json"
        -o "$temp_response"
        -D "$temp_headers"
    )

    if [[ -n "$payload" ]]; then
        curl_args+=(-H "Content-Type: application/json" -d "$payload")
    fi

    curl_args+=(-X "$method" "$api_url")

    # Execute request
    local http_status
    if ! http_status=$("$http_client" "${curl_args[@]}" 2>/dev/null); then
        log_error "HTTP request failed for: $method $endpoint"
        cleanup_temp_files "$temp_response" "$temp_headers"
        return 1
    fi

    # Process response
    if [[ "$http_status" =~ ^2[0-9][0-9]$ ]]; then
        case "$response_format" in
            "json")
                cat "$temp_response"
                ;;
            "raw")
                cat "$temp_response"
                ;;
            "headers")
                cat "$temp_headers"
                ;;
        esac
        cleanup_temp_files "$temp_response" "$temp_headers"
        return 0
    else
        log_error "API request failed with status $http_status: $method $endpoint"
        log_error "Response: $(cat "$temp_response")"
        cleanup_temp_files "$temp_response" "$temp_headers"
        return 1
    fi
}

# Payload creation helpers
create_repository_payload() {
    local name="$1"
    local description="$2"
    local is_private="$3"
    local auto_init="$4"

    cat << EOF
{
    "name": "$name",
    "description": "$description",
    "private": $is_private,
    "auto_init": $auto_init,
    "has_issues": true,
    "has_projects": true,
    "has_wiki": false
}
EOF
}

create_issue_payload() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local assignees="$4"

    local json_processor="${GITHUB_CLIENT_DEPENDENCIES[json_processor]}"

    # Build JSON payload dynamically
    echo '{}' | \
    "$json_processor" \
        --arg title "$title" \
        --arg body "$body" \
        --argjson labels "$(echo "$labels" | "$json_processor" -R -s 'split(",") | map(select(length > 0))')" \
        --argjson assignees "$(echo "$assignees" | "$json_processor" -R -s 'split(",") | map(select(length > 0))')" \
        '{
            title: $title,
            body: $body,
            labels: $labels,
            assignees: $assignees
        }'
}

cleanup_temp_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        [[ -f "$file" ]] && rm -f "$file"
    done
}
```

#### Code Organization Best Practices

##### 1. Directory Structure Standards

```bash
scripts/
├── includes/                 # Reusable function libraries
│   ├── core/                 # Core system functions
│   │   ├── logging.sh        # Logging and output functions
│   │   ├── config.sh         # Configuration management
│   │   └── error-handling.sh # Error handling and recovery
│   ├── validation/           # Input and data validation
│   │   ├── input-validation.sh
│   │   ├── file-validation.sh
│   │   └── network-validation.sh
│   ├── interfaces/           # External system interfaces
│   │   ├── github-interface.sh
│   │   ├── docker-interface.sh
│   │   └── aws-interface.sh
│   ├── utilities/            # Utility and helper functions
│   │   ├── string-utils.sh
│   │   ├── file-utils.sh
│   │   └── date-utils.sh
│   └── testing/              # Testing support functions
│       ├── test-helpers.sh
│       ├── mock-functions.sh
│       └── assertions.sh
├── deployment/               # Deployment automation scripts
├── maintenance/              # Maintenance and housekeeping scripts
├── project/                  # Project-specific automation
└── utility/                  # General utility scripts

tests/
├── includes/                 # Tests for include functions
│   ├── core/
│   ├── validation/
│   ├── interfaces/
│   ├── utilities/
│   └── testing/
├── integration/              # Integration tests
├── performance/              # Performance tests
└── security/                 # Security tests
```

##### 2. Naming Conventions and Standards

```bash
#!/bin/bash
# scripts/includes/conventions/naming-standards.sh

# Function naming conventions
# Format: [scope]_[action]_[object]
# Examples:
#   validate_email_format()     # validation scope
#   github_create_repository()  # interface scope
#   log_error_message()         # utility scope
#   test_assert_equals()        # testing scope

# Variable naming conventions
# Constants: UPPER_SNAKE_CASE
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_TIMEOUT=300
readonly CONFIG_FILE_PATH="/etc/lightspeed/config.yml"

# Global variables: lower_snake_case with descriptive prefixes
script_execution_id=""
github_api_base_url=""
validation_error_count=0

# Local variables: lower_snake_case
function process_user_input() {
    local user_input="$1"
    local validation_result=""
    local processed_output=""

    # Processing logic here
}

# File and directory naming
# Scripts: kebab-case with descriptive names
# deploy-wordpress-site.sh
# validate-backup-integrity.sh
# sync-organization-labels.sh

# Include files: category-purpose.sh
# core-logging.sh
# validation-input.sh
# github-interface.sh

# Configuration files: kebab-case with extension
# deployment-config.yml
# label-standards.json
# monitoring-alerts.yml
```

#### Performance Best Practices

##### 1. Efficient Resource Management

```bash
#!/bin/bash
# scripts/includes/performance/resource-management.sh

# ============================================================================
# Script Name: resource-management.sh
# Description: Performance-optimized resource management for shell scripts
# Usage: source scripts/includes/performance/resource-management.sh
# Examples:
#   # Memory management
#   optimize_memory_usage
#   monitor_memory_consumption
#
#   # Process management
#   manage_concurrent_processes 4
#   wait_for_process_completion
#
#   # File I/O optimization
#   batch_file_operations "*.txt" "process_text_file"
#   optimize_large_file_processing "/path/to/large/file"
# ============================================================================

set -euo pipefail

readonly MAX_CONCURRENT_PROCESSES="${MAX_CONCURRENT_PROCESSES:-4}"
readonly MEMORY_THRESHOLD_MB="${MEMORY_THRESHOLD_MB:-1024}"
readonly TEMP_CLEANUP_INTERVAL="${TEMP_CLEANUP_INTERVAL:-300}"

declare -a active_processes=()
declare -A process_memory_usage=()

optimize_memory_usage() {
    log_info "Optimizing memory usage"

    # Clear unnecessary variables
    unset large_arrays 2>/dev/null || true

    # Force garbage collection for bash arrays
    declare -A temp_cleanup=()
    temp_cleanup["dummy"]="value"
    unset temp_cleanup

    # Set memory limits if ulimit available
    if command -v ulimit >/dev/null 2>&1; then
        ulimit -v $((MEMORY_THRESHOLD_MB * 1024)) 2>/dev/null || true
    fi

    log_success "Memory optimization completed"
}

monitor_memory_consumption() {
    local process_pid="${1:-$$}"
    local warning_threshold="${2:-$MEMORY_THRESHOLD_MB}"

    if command -v ps >/dev/null 2>&1; then
        local memory_usage_kb=$(ps -o rss= -p "$process_pid" 2>/dev/null | tr -d ' ' || echo "0")
        local memory_usage_mb=$((memory_usage_kb / 1024))

        process_memory_usage["$process_pid"]="$memory_usage_mb"

        if [[ $memory_usage_mb -gt $warning_threshold ]]; then
            log_warning "High memory usage detected: ${memory_usage_mb}MB (PID: $process_pid)"
            return 1
        fi

        log_debug "Memory usage: ${memory_usage_mb}MB (PID: $process_pid)"
        return 0
    else
        log_warning "Memory monitoring not available (ps command not found)"
        return 0
    fi
}

manage_concurrent_processes() {
    local max_processes="${1:-$MAX_CONCURRENT_PROCESSES}"
    local command_to_run="$2"
    shift 2
    local process_args=("$@")

    log_info "Managing concurrent processes: max=$max_processes"

    # Wait if we're at the limit
    while [[ ${#active_processes[@]} -ge $max_processes ]]; do
        wait_for_process_completion
        sleep 1
    done

    # Start new process
    "$command_to_run" "${process_args[@]}" &
    local new_pid=$!

    active_processes+=("$new_pid")
    log_debug "Started process: PID=$new_pid, Active=${#active_processes[@]}"

    return 0
}

wait_for_process_completion() {
    local updated_processes=()

    for pid in "${active_processes[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            # Process still running
            updated_processes+=("$pid")
        else
            # Process completed
            wait "$pid" 2>/dev/null || true
            log_debug "Process completed: PID=$pid"
            unset process_memory_usage["$pid"]
        fi
    done

    active_processes=("${updated_processes[@]}")
}

wait_for_all_processes() {
    log_info "Waiting for all processes to complete: ${#active_processes[@]} active"

    for pid in "${active_processes[@]}"; do
        wait "$pid" 2>/dev/null || log_warning "Process $pid exited with error"
    done

    active_processes=()
    process_memory_usage=()

    log_success "All processes completed"
}

batch_file_operations() {
    local file_pattern="$1"
    local operation_function="$2"
    local batch_size="${3:-10}"

    log_info "Starting batch file operations: pattern=$file_pattern, batch_size=$batch_size"

    local files_array=()
    local processed_count=0

    # Build file array
    while IFS= read -r -d '' file; do
        files_array+=("$file")
    done < <(find . -name "$file_pattern" -type f -print0)

    local total_files=${#files_array[@]}
    log_info "Found $total_files files matching pattern: $file_pattern"

    # Process files in batches
    for ((i = 0; i < total_files; i += batch_size)); do
        local batch_end=$((i + batch_size))
        [[ $batch_end -gt $total_files ]] && batch_end=$total_files

        log_debug "Processing batch: files $((i + 1)) to $batch_end"

        # Process batch
        for ((j = i; j < batch_end; j++)); do
            local file="${files_array[j]}"
            manage_concurrent_processes "$MAX_CONCURRENT_PROCESSES" "$operation_function" "$file"
        done

        # Wait for batch completion
        wait_for_all_processes

        processed_count=$batch_end
        log_info "Batch completed: $processed_count/$total_files files processed"
    done

    log_success "Batch file operations completed: $processed_count files processed"
}

optimize_large_file_processing() {
    local file_path="$1"
    local chunk_size="${2:-1000}"
    local processing_function="$3"

    log_info "Optimizing large file processing: $file_path (chunk_size=$chunk_size)"

    if [[ ! -f "$file_path" ]]; then
        log_error "File not found: $file_path"
        return 1
    fi

    local temp_dir="/tmp/file_chunks_$$"
    mkdir -p "$temp_dir"

    # Split file into chunks
    split -l "$chunk_size" "$file_path" "$temp_dir/chunk_" || {
        log_error "Failed to split file: $file_path"
        rm -rf "$temp_dir"
        return 1
    }

    # Process chunks in parallel
    local chunk_files=("$temp_dir"/chunk_*)
    log_info "Split into ${#chunk_files[@]} chunks"

    if [[ -n "$processing_function" ]]; then
        for chunk_file in "${chunk_files[@]}"; do
            manage_concurrent_processes "$MAX_CONCURRENT_PROCESSES" "$processing_function" "$chunk_file"
        done

        wait_for_all_processes
    fi

    # Cleanup
    rm -rf "$temp_dir"

    log_success "Large file processing completed: $file_path"
}

setup_periodic_cleanup() {
    local cleanup_interval="${1:-$TEMP_CLEANUP_INTERVAL}"

    log_info "Setting up periodic cleanup: interval=${cleanup_interval}s"

    # Background cleanup process
    (
        while true; do
            sleep "$cleanup_interval"

            # Clean up temporary files older than cleanup interval
            find /tmp -name "lightspeed_*" -type f -mmin +$((cleanup_interval / 60)) -delete 2>/dev/null || true
            find /tmp -name "*_$$" -type f -mmin +$((cleanup_interval / 60)) -delete 2>/dev/null || true

            # Monitor and log memory usage
            monitor_memory_consumption $$

            log_debug "Periodic cleanup completed"
        done
    ) &

    local cleanup_pid=$!

    # Set up cleanup trap
    trap "kill $cleanup_pid 2>/dev/null || true" EXIT

    log_success "Periodic cleanup initialized: PID=$cleanup_pid"
}
```

## System Constraints

- Modular components must maintain backward compatibility across versions
- Performance overhead from modularization must be minimized
- Security boundaries between modules must be clearly defined
- Testing coverage must be comprehensive for all modular components
- Documentation must be automatically generated and kept current

## Example First Message to Copilot

```text
Implement comprehensive best practices for shell script modularization. Create architectural guidelines covering single responsibility, interface design, performance optimization, security considerations, and maintainability patterns for enterprise automation systems.
```

## Verification Steps

- [ ] Modular components follow single responsibility principle
- [ ] Interfaces are well-defined with proper dependency injection
- [ ] Performance optimizations are implemented without compromising maintainability
- [ ] Security best practices are enforced across all modules
- [ ] Testing coverage meets enterprise standards for all components
- [ ] Documentation is comprehensive and automatically maintained

## References

- [Script Functions Breakdown Specification](./script-functions-breakdown-spec.md)
- [Security Considerations for Modular Shell Scripts](./security-considerations-for-modular-shell-scripts.md)
- [Performance and Optimization Guidelines](./github-copilot-performance-and-optimization-guidelines.md)

## Closing Statement

Comprehensive best practices for shell script modularization ensure maintainable, secure, and performant automation systems that scale effectively while promoting code reuse and reducing technical debt across enterprise environments.

