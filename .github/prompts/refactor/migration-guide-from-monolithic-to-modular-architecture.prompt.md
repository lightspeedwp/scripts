---
applyTo: '**'
description: 'Prompt for migration guide from monolithic to modular shell script architecture.'
version: '1.0.0'
author: 'LightSpeed WP Team'
status: 'draft'
changelog: ['2025-10-17: Initial version']
tags: ['migration', 'modular', 'shell', 'architecture']
feedback: 'Submit suggestions or issues via repository discussions or PR comments.'
updated: '2025-10-17'
created: '2025-10-17'
---

# Migration Guide from Monolithic to Modular Architecture

## Role

You are a migration specialist for shell script architecture transformation. Follow our LightSpeed WP standards to guide developers through the systematic process of converting existing monolithic shell scripts into modular, maintainable components using the includes architecture.

## Purpose

Provide a comprehensive, step-by-step migration methodology that transforms existing shell script codebases from monolithic designs to modular architectures while preserving functionality, improving maintainability, and reducing technical debt.

## Checklist

- [ ] Establish pre-migration assessment and planning procedures
- [ ] Define systematic function extraction and modularization processes
- [ ] Create validation and testing strategies for migrated components
- [ ] Implement rollback and recovery procedures for failed migrations
- [ ] Define post-migration optimization and maintenance workflows
- [ ] Create documentation and knowledge transfer processes

## Instructions

### Pre-Migration Assessment

#### Codebase Analysis Framework

##### 1. Monolithic Script Inventory

```bash
#!/bin/bash
# scripts/migration/analyze-codebase.sh

# Function: analyze_script_structure
# Description: Analyze existing scripts to identify migration opportunities
# Arguments:
#   $1 - Directory containing scripts to analyze
#   $2 - Output directory for analysis reports
analyze_script_structure() {
    local scripts_dir="$1"
    local output_dir="$2"
    local analysis_report="$output_dir/codebase-analysis.json"

    mkdir -p "$output_dir"

    log_info "Analyzing codebase structure in $scripts_dir"

    # Initialize analysis report
    cat > "$analysis_report" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "scripts": {},
    "summary": {
        "total_scripts": 0,
        "total_functions": 0,
        "common_patterns": {},
        "migration_candidates": []
    }
}
EOF

    # Analyze each shell script
    while IFS= read -r -d '' script_file; do
        analyze_individual_script "$script_file" "$analysis_report"
    done < <(find "$scripts_dir" -name "*.sh" -type f -print0)

    # Generate migration recommendations
    generate_migration_recommendations "$analysis_report"

    log_success "Codebase analysis completed: $analysis_report"
}

# Function: analyze_individual_script
# Description: Extract detailed information about a single script
# Arguments:
#   $1 - Path to script file
#   $2 - Analysis report file to update
analyze_individual_script() {
    local script_file="$1"
    local report_file="$2"
    local script_name=$(basename "$script_file")

    log_debug "Analyzing script: $script_name"

    # Extract script metrics
    local line_count=$(wc -l < "$script_file")
    local function_count=$(grep -c '^[a-zA-Z_][a-zA-Z0-9_]*() {' "$script_file")
    local include_count=$(grep -c '^source\|^\.' "$script_file")
    local external_command_count=$(grep -co '\b\(git\|curl\|wget\|ssh\|scp\)\b' "$script_file")

    # Extract functions
    local functions=($(grep '^[a-zA-Z_][a-zA-Z0-9_]*() {' "$script_file" | sed 's/() {//'))

    # Identify common patterns
    local has_logging=$(grep -q 'log_\|echo.*\[\(INFO\|ERROR\|SUCCESS\)' "$script_file" && echo true || echo false)
    local has_validation=$(grep -q 'validate_\|check_\|\[\[ .*-[fder]' "$script_file" && echo true || echo false)
    local has_file_ops=$(grep -q '\(cp\|mv\|rm\|mkdir\|chmod\)' "$script_file" && echo true || echo false)
    local has_git_ops=$(grep -q '\bgit\b' "$script_file" && echo true || echo false)
    local has_network_ops=$(grep -q '\(curl\|wget\|ssh\|scp\)' "$script_file" && echo true || echo false)

    # Calculate complexity score
    local complexity_score=$(( line_count / 100 + function_count * 5 + external_command_count * 2 ))

    # Determine migration priority
    local migration_priority="LOW"
    if [[ $complexity_score -gt 50 ]]; then
        migration_priority="HIGH"
    elif [[ $complexity_score -gt 25 ]]; then
        migration_priority="MEDIUM"
    fi

    # Update analysis report
    jq --arg name "$script_name" \
       --arg path "$script_file" \
       --argjson lines "$line_count" \
       --argjson funcs "$function_count" \
       --argjson includes "$include_count" \
       --argjson ext_cmds "$external_command_count" \
       --argjson complexity "$complexity_score" \
       --arg priority "$migration_priority" \
       --argjson has_log "$has_logging" \
       --argjson has_val "$has_validation" \
       --argjson has_file "$has_file_ops" \
       --argjson has_git "$has_git_ops" \
       --argjson has_net "$has_network_ops" \
       --argjson func_list "$(printf '%s\n' "${functions[@]}" | jq -R . | jq -s .)" \
       '.scripts[$name] = {
           "path": $path,
           "metrics": {
               "lines": $lines,
               "functions": $funcs,
               "includes": $includes,
               "external_commands": $ext_cmds,
               "complexity_score": $complexity
           },
           "patterns": {
               "logging": $has_log,
               "validation": $has_val,
               "file_operations": $has_file,
               "git_operations": $has_git,
               "network_operations": $has_net
           },
           "functions": $func_list,
           "migration_priority": $priority
       }' "$report_file" > "$report_file.tmp" && mv "$report_file.tmp" "$report_file"
}

# Function: generate_migration_recommendations
# Description: Generate specific migration recommendations based on analysis
generate_migration_recommendations() {
    local report_file="$1"

    # Identify common functions across scripts
    local common_functions=$(jq -r '
        [.scripts[].functions[]] |
        group_by(.) |
        map({function: .[0], count: length}) |
        sort_by(.count) |
        reverse |
        map(select(.count > 1)) |
        map(.function)' "$report_file")

    # Generate recommendations
    jq --argjson common_funcs "$common_functions" '
        .summary.total_scripts = (.scripts | length) |
        .summary.total_functions = ([.scripts[].metrics.functions] | add) |
        .summary.common_functions = $common_funcs |
        .summary.migration_candidates = [
            .scripts |
            to_entries[] |
            select(.value.migration_priority == "HIGH") |
            .key
        ]' "$report_file" > "$report_file.tmp" && mv "$report_file.tmp" "$report_file"
}
```

##### 2. Dependency Analysis

```bash
# Function: analyze_dependencies
# Description: Map dependencies between scripts and external tools
analyze_dependencies() {
    local scripts_dir="$1"
    local output_file="$2"

    log_info "Analyzing script dependencies"

    # Initialize dependency mapping
    cat > "$output_file" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "script_dependencies": {},
    "external_dependencies": {},
    "dependency_graph": {}
}
EOF

    # Analyze each script
    while IFS= read -r -d '' script_file; do
        local script_name=$(basename "$script_file")

        # Find script-to-script dependencies
        local sourced_scripts=($(grep -o 'source [^[:space:]]*\.sh\|\. [^[:space:]]*\.sh' "$script_file" | \
                               awk '{print $2}' | sort -u))

        # Find external command dependencies
        local external_commands=($(grep -ho '\b\(git\|curl\|wget\|ssh\|scp\|jq\|yq\|docker\|kubectl\)\b' "$script_file" | \
                                 sort -u))

        # Update dependency report
        jq --arg script "$script_name" \
           --argjson sourced "$(printf '%s\n' "${sourced_scripts[@]}" | jq -R . | jq -s .)" \
           --argjson external "$(printf '%s\n' "${external_commands[@]}" | jq -R . | jq -s .)" \
           '.script_dependencies[$script] = $sourced |
            .external_dependencies[$script] = $external' \
           "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"

    done < <(find "$scripts_dir" -name "*.sh" -type f -print0)

    log_success "Dependency analysis completed: $output_file"
}
```

### Migration Planning Process

#### Step-by-Step Migration Strategy

##### 1. Migration Plan Generation

```bash
# scripts/migration/generate-migration-plan.sh

generate_migration_plan() {
    local analysis_report="$1"
    local migration_plan_file="$2"

    log_info "Generating migration plan from analysis"

    # Create migration plan structure
    cat > "$migration_plan_file" << EOF
# LightSpeed WP Modular Migration Plan

## Generated: $(date)

## Migration Overview
$(generate_migration_overview "$analysis_report")

## Phase 1: Foundation Setup
$(generate_foundation_phase)

## Phase 2: Core Includes Creation
$(generate_includes_phase "$analysis_report")

## Phase 3: Script Migration
$(generate_script_migration_phase "$analysis_report")

## Phase 4: Testing and Validation
$(generate_testing_phase)

## Phase 5: Cleanup and Optimization
$(generate_cleanup_phase)

## Timeline and Resources
$(generate_timeline_estimates "$analysis_report")

## Risk Assessment
$(generate_risk_assessment "$analysis_report")
EOF

    log_success "Migration plan generated: $migration_plan_file"
}

generate_migration_overview() {
    local analysis_report="$1"

    local total_scripts=$(jq -r '.summary.total_scripts' "$analysis_report")
    local high_priority=$(jq -r '.summary.migration_candidates | length' "$analysis_report")
    local total_functions=$(jq -r '.summary.total_functions' "$analysis_report")

    cat << EOF
- **Total Scripts**: $total_scripts
- **High Priority Migrations**: $high_priority
- **Total Functions**: $total_functions
- **Estimated Duration**: $(calculate_migration_duration "$total_scripts" "$total_functions") weeks
- **Required Resources**: 1-2 developers, QA support
EOF
}

generate_includes_phase() {
    local analysis_report="$1"

    cat << EOF
### Core Includes to Create

$(jq -r '.summary.common_functions[]' "$analysis_report" | while read -r func; do
    echo "- **$func**: Extract and modularize common $func functionality"
done)

### Include Categories

1. **Core Utilities**
   - logging.sh (standardized logging functions)
   - validation.sh (input validation and checks)
   - error-handling.sh (error reporting and recovery)

2. **File Operations**
   - file-operations.sh (safe file manipulation)
   - path-utils.sh (path resolution and validation)
   - backup-restore.sh (backup and restore operations)

3. **External Integrations**
   - git-utils.sh (Git repository operations)
   - api-client.sh (HTTP/API communication)
   - ssh-utils.sh (SSH and remote operations)

### Implementation Order
1. Start with logging and validation (most commonly used)
2. Extract file operations (high impact, moderate complexity)
3. Implement external integrations (complex but isolated)
EOF
}
```

##### 2. Function Extraction Process

```bash
# scripts/migration/extract-functions.sh

# Function: extract_function_to_include
# Description: Extract a specific function from a script to an include file
# Arguments:
#   $1 - Source script path
#   $2 - Function name to extract
#   $3 - Target include file path
#   $4 - Include category (core|utilities|integrations)
extract_function_to_include() {
    local source_script="$1"
    local function_name="$2"
    local target_include="$3"
    local include_category="$4"

    log_info "Extracting $function_name from $source_script to $target_include"

    # Validate function exists in source script
    if ! grep -q "^$function_name() {" "$source_script"; then
        log_error "Function $function_name not found in $source_script"
        return 1
    fi

    # Create include file if it doesn't exist
    if [[ ! -f "$target_include" ]]; then
        create_include_file_template "$target_include" "$include_category"
    fi

    # Extract function definition
    local function_content
    function_content=$(extract_function_definition "$source_script" "$function_name")

    if [[ -z "$function_content" ]]; then
        log_error "Failed to extract function content for $function_name"
        return 1
    fi

    # Add function to include file
    add_function_to_include "$target_include" "$function_name" "$function_content"

    # Update source script to use include
    update_source_script_for_include "$source_script" "$function_name" "$target_include"

    log_success "Function $function_name extracted successfully"
}

# Function: extract_function_definition
# Description: Extract complete function definition including comments
extract_function_definition() {
    local source_file="$1"
    local func_name="$2"

    # Find function start and end
    local start_line end_line
    start_line=$(grep -n "^$func_name() {" "$source_file" | cut -d: -f1)

    if [[ -z "$start_line" ]]; then
        return 1
    fi

    # Extract function with balanced braces
    local brace_count=0
    local line_num=$start_line
    local in_function=false

    while IFS= read -r line; do
        if [[ $line_num -eq $start_line ]]; then
            in_function=true
        fi

        if [[ "$in_function" == "true" ]]; then
            # Count braces to find function end
            local open_braces=$(echo "$line" | tr -cd '{' | wc -c)
            local close_braces=$(echo "$line" | tr -cd '}' | wc -c)
            brace_count=$((brace_count + open_braces - close_braces))

            if [[ $brace_count -eq 0 ]] && [[ $line_num -gt $start_line ]]; then
                end_line=$line_num
                break
            fi
        fi

        ((line_num++))
    done < "$source_file"

    # Include preceding comment lines
    local comment_start=$start_line
    while [[ $comment_start -gt 1 ]]; do
        local prev_line=$(sed -n "$((comment_start - 1))p" "$source_file")
        if [[ "$prev_line" =~ ^[[:space:]]*# ]] || [[ -z "$prev_line" ]]; then
            ((comment_start--))
        else
            break
        fi
    done

    # Extract function with comments
    sed -n "${comment_start},${end_line}p" "$source_file"
}

# Function: add_function_to_include
# Description: Add extracted function to include file
add_function_to_include() {
    local include_file="$1"
    local func_name="$2"
    local func_content="$3"

    # Check if function already exists in include
    if grep -q "^$func_name() {" "$include_file"; then
        log_warning "Function $func_name already exists in $include_file"
        return 0
    fi

    # Add function to include file (before the closing comment)
    local temp_file=$(mktemp)

    # Copy everything except the final closing comment
    grep -v "^# End of" "$include_file" > "$temp_file"

    # Add the new function
    echo "" >> "$temp_file"
    echo "$func_content" >> "$temp_file"
    echo "" >> "$temp_file"

    # Add closing comment back
    echo "# End of $(basename "$include_file")" >> "$temp_file"

    # Replace original file
    mv "$temp_file" "$include_file"

    log_debug "Added function $func_name to $include_file"
}

# Function: update_source_script_for_include
# Description: Update original script to use include instead of local function
update_source_script_for_include() {
    local source_script="$1"
    local func_name="$2"
    local include_file="$3"

    # Add source statement if not already present
    local include_name=$(basename "$include_file")
    local source_line="source \"\$(dirname \"\${BASH_SOURCE[0]}\")/../includes/$(basename "$(dirname "$include_file")")/$include_name\""

    if ! grep -q "source.*$include_name" "$source_script"; then
        # Find a good place to add the source statement (after shebang and before main code)
        local insert_line=1
        while IFS= read -r line; do
            ((insert_line++))
            if [[ "$line" =~ ^#! ]] || [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
                continue
            else
                break
            fi
        done < "$source_script"

        # Insert source statement
        sed -i "${insert_line}i\\
$source_line" "$source_script"
    fi

    # Remove the function definition from source script
    local temp_file=$(mktemp)
    local skip_function=false
    local brace_count=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^$func_name\(\)[[:space:]]*\{ ]]; then
            skip_function=true
            brace_count=1
            continue
        fi

        if [[ "$skip_function" == "true" ]]; then
            local open_braces=$(echo "$line" | tr -cd '{' | wc -c)
            local close_braces=$(echo "$line" | tr -cd '}' | wc -c)
            brace_count=$((brace_count + open_braces - close_braces))

            if [[ $brace_count -eq 0 ]]; then
                skip_function=false
            fi
            continue
        fi

        echo "$line" >> "$temp_file"
    done < "$source_script"

    mv "$temp_file" "$source_script"

    log_debug "Updated $source_script to use include for $func_name"
}
```

### Validation and Testing Strategy

#### Migration Validation Framework

##### 1. Pre/Post Migration Testing

```bash
# scripts/migration/validate-migration.sh

# Function: create_migration_tests
# Description: Generate validation tests for migrated scripts
create_migration_tests() {
    local original_script="$1"
    local migrated_script="$2"
    local test_file="$3"

    log_info "Creating migration validation tests"

    # Generate Bats test file
    cat > "$test_file" << EOF
#!/usr/bin/env bats

# Migration validation tests for $(basename "$original_script")
# Generated: $(date)

setup() {
    # Load test helpers
    load "\$(dirname "\$BATS_TEST_FILENAME")/../../test-helper.bash"

    # Set up test environment
    ORIGINAL_SCRIPT="$original_script"
    MIGRATED_SCRIPT="$migrated_script"
    TEST_TEMP_DIR="\$(mktemp -d)"
    export TEST_TEMP_DIR
}

teardown() {
    # Clean up test environment
    [[ -n "\$TEST_TEMP_DIR" && -d "\$TEST_TEMP_DIR" ]] && rm -rf "\$TEST_TEMP_DIR"
}

# ----- Section: Migration Validation Tests -----

EOF

    # Generate function compatibility tests
    generate_function_tests "$original_script" "$test_file"

    # Generate behavior equivalency tests
    generate_behavior_tests "$original_script" "$migrated_script" "$test_file"

    # Generate performance comparison tests
    generate_performance_tests "$original_script" "$migrated_script" "$test_file"

    log_success "Migration tests created: $test_file"
}

generate_function_tests() {
    local script_file="$1"
    local test_file="$2"

    # Extract all functions from the script
    local functions=($(grep '^[a-zA-Z_][a-zA-Z0-9_]*() {' "$script_file" | sed 's/() {//'))

    for func in "${functions[@]}"; do
        cat >> "$test_file" << EOF
# ============================================================================
# Test Name: "function $func is available after migration"
# Test Type: Migration Validation
# Test Scope: Validates that function $func remains available and callable after migration
# ============================================================================
@test "function $func is available after migration" {
    # Source migrated script
    source "\$MIGRATED_SCRIPT"

    # Check if function is defined
    declare -f "$func" > /dev/null

    # Verify function is callable (basic smoke test)
    [[ \$(type -t "$func") == "function" ]]
}

EOF
    done
}

generate_behavior_tests() {
    local original_script="$1"
    local migrated_script="$2"
    local test_file="$3"

    cat >> "$test_file" << EOF
# ============================================================================
# Test Name: "migrated script produces equivalent output"
# Test Type: Behavior Equivalency
# Test Scope: Validates that migrated script produces same output as original for standard inputs
# ============================================================================
@test "migrated script produces equivalent output" {
    local test_input="test-data.txt"
    echo "sample test data" > "\$TEST_TEMP_DIR/\$test_input"

    # Run original script (if it can run safely in test mode)
    local original_output=""
    if grep -q "dry.*run\|test.*mode" "\$ORIGINAL_SCRIPT"; then
        original_output=\$(cd "\$TEST_TEMP_DIR" && bash "\$ORIGINAL_SCRIPT" --dry-run 2>&1 || echo "FAILED")
    else
        skip "Original script does not support safe test execution"
    fi

    # Run migrated script
    local migrated_output=""
    if grep -q "dry.*run\|test.*mode" "\$MIGRATED_SCRIPT"; then
        migrated_output=\$(cd "\$TEST_TEMP_DIR" && bash "\$MIGRATED_SCRIPT" --dry-run 2>&1 || echo "FAILED")
    else
        skip "Migrated script does not support safe test execution"
    fi

    # Compare outputs (basic equivalency)
    [[ "\$original_output" == "\$migrated_output" ]]
}

EOF
}
```

##### 2. Rollback Procedures

```bash
# scripts/migration/rollback-migration.sh

# Function: create_rollback_point
# Description: Create rollback point before migration
create_rollback_point() {
    local script_path="$1"
    local rollback_dir="$2"

    local script_name=$(basename "$script_path")
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local backup_path="$rollback_dir/${script_name}.pre-migration.$timestamp"

    mkdir -p "$rollback_dir"

    # Create backup with metadata
    cp "$script_path" "$backup_path"

    # Create rollback metadata
    cat > "$backup_path.meta" << EOF
{
    "original_path": "$script_path",
    "backup_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "migration_phase": "pre-migration",
    "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo "not-in-git")",
    "file_hash": "$(sha256sum "$script_path" | cut -d' ' -f1)"
}
EOF

    log_info "Rollback point created: $backup_path"
    echo "$backup_path"
}

# Function: execute_rollback
# Description: Rollback migration to previous state
execute_rollback() {
    local rollback_file="$1"
    local reason="${2:-Manual rollback requested}"

    if [[ ! -f "$rollback_file" ]]; then
        log_error "Rollback file not found: $rollback_file"
        return 1
    fi

    if [[ ! -f "$rollback_file.meta" ]]; then
        log_error "Rollback metadata not found: $rollback_file.meta"
        return 1
    fi

    # Read rollback metadata
    local original_path=$(jq -r '.original_path' "$rollback_file.meta")
    local backup_hash=$(jq -r '.file_hash' "$rollback_file.meta")

    # Verify backup integrity
    local current_backup_hash=$(sha256sum "$rollback_file" | cut -d' ' -f1)
    if [[ "$current_backup_hash" != "$backup_hash" ]]; then
        log_error "Backup file integrity check failed"
        return 1
    fi

    # Create backup of current state before rollback
    local current_backup="${original_path}.rollback-backup.$(date +%Y%m%d-%H%M%S)"
    if [[ -f "$original_path" ]]; then
        cp "$original_path" "$current_backup"
        log_info "Current state backed up to: $current_backup"
    fi

    # Perform rollback
    cp "$rollback_file" "$original_path"

    # Log rollback action
    log_success "Rollback completed: $original_path restored from $rollback_file"
    log_info "Rollback reason: $reason"

    # Create rollback record
    cat >> "rollback-log.json" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "file": "$original_path",
    "backup_used": "$rollback_file",
    "reason": "$reason",
    "current_backup": "$current_backup"
}
EOF
}
```

### Post-Migration Optimization

#### Performance and Maintenance

##### 1. Include Optimization

```bash
# scripts/migration/optimize-includes.sh

# Function: optimize_include_loading
# Description: Optimize include loading performance and dependencies
optimize_include_loading() {
    local scripts_dir="$1"

    log_info "Optimizing include loading across scripts"

    # Analyze include usage patterns
    analyze_include_usage "$scripts_dir"

    # Optimize include dependencies
    optimize_include_dependencies "$scripts_dir"

    # Create include loader optimization
    create_optimized_loader "$scripts_dir"
}

analyze_include_usage() {
    local scripts_dir="$1"
    local usage_report="include-usage-$(date +%Y%m%d-%H%M%S).json"

    # Map which includes are used by which scripts
    cat > "$usage_report" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "include_usage": {},
    "optimization_opportunities": []
}
EOF

    # Analyze each script
    while IFS= read -r -d '' script_file; do
        local script_name=$(basename "$script_file")
        local includes=($(grep -o 'source.*includes/[^[:space:]]*\.sh' "$script_file" | \
                         awk '{print $2}' | sed 's/.*includes\///'))

        # Update usage report
        jq --arg script "$script_name" \
           --argjson includes "$(printf '%s\n' "${includes[@]}" | jq -R . | jq -s .)" \
           '.include_usage[$script] = $includes' \
           "$usage_report" > "$usage_report.tmp" && mv "$usage_report.tmp" "$usage_report"

    done < <(find "$scripts_dir" -name "*.sh" -type f -print0)

    log_info "Include usage analysis completed: $usage_report"
}

create_optimized_loader() {
    local scripts_dir="$1"
    local loader_file="$scripts_dir/includes/core/optimized-loader.sh"

    # Create optimized include loader
    cat > "$loader_file" << EOF
#!/bin/bash

# ============================================================================
# Script Name: optimized-loader.sh
# Description: Optimized include loading system for LightSpeed WP scripts
# Version: v1.0.0
# Author: LightSpeed WP Team
# Usage: source "path/to/optimized-loader.sh" then use load_includes function
# Notes: Provides caching, dependency resolution, and performance optimization
# ============================================================================

set -euo pipefail

# Include loading cache
declare -A LOADED_INCLUDES=()
declare -A INCLUDE_DEPENDENCIES=()

# Function: load_includes
# Description: Load multiple includes efficiently with dependency resolution
# Arguments: $@ - List of include names to load
load_includes() {
    local includes=("\$@")
    local load_order=()

    # Resolve dependencies and determine load order
    for include in "\${includes[@]}"; do
        resolve_include_dependencies "\$include" load_order
    done

    # Load includes in dependency order
    for include in "\${load_order[@]}"; do
        load_include_once "\$include"
    done
}

# Function: load_include_once
# Description: Load an include file only once (cached loading)
load_include_once() {
    local include_name="\$1"

    # Check if already loaded
    if [[ -n "\${LOADED_INCLUDES[\$include_name]:-}" ]]; then
        return 0
    fi

    # Find and load include file
    local include_path
    if ! include_path=\$(find_include_path "\$include_name"); then
        log_error "Include not found: \$include_name"
        return 1
    fi

    # Load the include
    source "\$include_path"
    LOADED_INCLUDES[\$include_name]="loaded"

    log_debug "Loaded include: \$include_name"
}

# Function: find_include_path
# Description: Locate include file in standard paths
find_include_path() {
    local include_name="\$1"
    local search_paths=(
        "\$(dirname "\${BASH_SOURCE[1]}")/../includes/core/\$include_name"
        "\$(dirname "\${BASH_SOURCE[1]}")/../includes/utilities/\$include_name"
        "\$(dirname "\${BASH_SOURCE[1]}")/../includes/integrations/\$include_name"
        "scripts/includes/core/\$include_name"
        "scripts/includes/utilities/\$include_name"
        "scripts/includes/integrations/\$include_name"
    )

    for path in "\${search_paths[@]}"; do
        if [[ -f "\$path" ]]; then
            echo "\$path"
            return 0
        fi
    done

    return 1
}
EOF

    log_success "Optimized loader created: $loader_file"
}
```

## System Constraints

- Migration must preserve all existing functionality
- Rollback procedures must be reliable and tested
- Performance impact during migration must be minimal
- Documentation must be updated throughout the process
- Testing coverage must be comprehensive

## Example First Message to Copilot

```text
Begin systematic migration of monolithic shell scripts to modular architecture. Start with codebase analysis, generate migration plan, and proceed with function extraction while maintaining full functionality and providing rollback capabilities.
```

## Verification Steps

- [ ] Pre-migration analysis identifies all migration opportunities
- [ ] Migration plan provides clear step-by-step guidance
- [ ] Function extraction preserves all original functionality
- [ ] Validation tests confirm behavior equivalency
- [ ] Rollback procedures work reliably when needed
- [ ] Post-migration optimization improves maintainability

## References

- [Script Functions Breakdown Spec](./script-functions-breakdown-spec.md)
- [Specific Implementation Examples](./specific-implementation-examples-for-each-component.md)
- [Documentation and Testing Integration Strategies](./documentation-and-testing-integration-strategies.md)

## Closing Statement

Systematic migration from monolithic to modular architecture transforms existing shell script codebases into maintainable, testable, and reusable components while preserving functionality and providing robust rollback capabilities for risk mitigation.
