#!/bin/bash

set -euo pipefail

# 
# Script Name: validate-release.sh
# Description: Validates that the repository is ready for release
# Usage: ./validate-release.sh [--version VERSION]
# Author: LightSpeed WP Team
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default values
EXPECTED_VERSION="0.1.0"
VERBOSE=false
EXIT_CODE=0

show_help() {
    cat << EOF
Validate Release Readiness

This script validates that the repository is ready for release by checking:
- Version consistency across files
- Workflow file validity
- Test coverage and passing status
- Documentation completeness
- Changelog format

Usage: $0 [OPTIONS]

Options:
    --version VERSION    Expected version (default: $EXPECTED_VERSION)
    --verbose, -v        Enable verbose output
    --help, -h           Show this help message

Examples:
    $0                           # Validate for default version
    $0 --version 0.2.0          # Validate for specific version
    $0 --verbose                # Show detailed validation steps
EOF
}

log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_warning() {
    echo "⚠️  $1"
}

log_error() {
    echo "❌ $1"
    EXIT_CODE=1
}

check_version_files() {
    log_info "Checking version consistency..."
    
    local version_found=false
    
    # Check VERSION file
    if [[ -f "$PROJECT_ROOT/VERSION" ]]; then
        local version_file_content
        version_file_content=$(cat "$PROJECT_ROOT/VERSION")
        if [[ "$version_file_content" == "$EXPECTED_VERSION" ]]; then
            log_success "VERSION file matches expected version: $EXPECTED_VERSION"
        else
            log_error "VERSION file contains '$version_file_content', expected '$EXPECTED_VERSION'"
        fi
        version_found=true
    fi
    
    # Check package.json
    if [[ -f "$PROJECT_ROOT/package.json" ]] && command -v jq >/dev/null 2>&1; then
        local package_version
        package_version=$(jq -r '.version' "$PROJECT_ROOT/package.json")
        if [[ "$package_version" == "$EXPECTED_VERSION" ]]; then
            log_success "package.json version matches: $EXPECTED_VERSION"
        else
            log_error "package.json contains version '$package_version', expected '$EXPECTED_VERSION'"
        fi
        version_found=true
    fi
    
    if [[ "$version_found" == false ]]; then
        log_warning "No version files found (VERSION or package.json)"
    fi
}

check_workflows() {
    log_info "Validating GitHub Actions workflows..."
    
    local workflow_dir="$PROJECT_ROOT/.github/workflows"
    if [[ ! -d "$workflow_dir" ]]; then
        log_error "No .github/workflows directory found"
        return
    fi
    
    # Check for essential workflows
    local required_workflows=("release.yml" "test.yml" "lint.yml")
    for workflow in "${required_workflows[@]}"; do
        if [[ -f "$workflow_dir/$workflow" ]]; then
            log_success "Required workflow found: $workflow"
        else
            log_error "Missing required workflow: $workflow"
        fi
    done
    
    # Validate YAML syntax
    if command -v python3 >/dev/null 2>&1; then
        for workflow_file in "$workflow_dir"/*.yml "$workflow_dir"/*.yaml; do
            if [[ -f "$workflow_file" ]]; then
                if python3 -c "import yaml; yaml.safe_load(open('$workflow_file'))" 2>/dev/null; then
                    if [[ "$VERBOSE" == true ]]; then
                        log_success "YAML syntax valid: $(basename "$workflow_file")"
                    fi
                else
                    log_error "Invalid YAML syntax: $(basename "$workflow_file")"
                fi
            fi
        done
    fi
}

check_tests() {
    log_info "Checking test coverage and status..."
    
    local test_dir="$PROJECT_ROOT/tests"
    if [[ ! -d "$test_dir" ]]; then
        log_error "No tests directory found"
        return
    fi
    
    # Count test files
    local bats_files
    bats_files=$(find "$test_dir" -name "*.bats" | wc -l)
    if [[ "$bats_files" -gt 0 ]]; then
        log_success "Found $bats_files bats test files"
    else
        log_warning "No bats test files found"
    fi
    
    # Check if bats is available for running tests
    if command -v bats >/dev/null 2>&1; then
        log_success "Bats testing framework available"
        
        # Run a quick test to see if tests execute
        if [[ "$VERBOSE" == true ]]; then
            log_info "Running test validation..."
            if bats "$test_dir"/test-*.bats >/dev/null 2>&1; then
                log_success "All tests pass"
            else
                log_warning "Some tests are failing (check with 'bats tests/test-*.bats')"
            fi
        fi
    else
        log_warning "Bats not installed - cannot validate test execution"
    fi
}

check_documentation() {
    log_info "Checking documentation completeness..."
    
    local required_docs=("README.md" "CHANGELOG.md" "CONTRIBUTING.md")
    for doc in "${required_docs[@]}"; do
        if [[ -f "$PROJECT_ROOT/$doc" ]]; then
            log_success "Documentation found: $doc"
        else
            log_error "Missing documentation: $doc"
        fi
    done
    
    # Check changelog format
    if [[ -f "$PROJECT_ROOT/CHANGELOG.md" ]]; then
        if grep -q "## \[$EXPECTED_VERSION\]" "$PROJECT_ROOT/CHANGELOG.md"; then
            log_success "Changelog contains entry for version $EXPECTED_VERSION"
        else
            log_warning "Changelog missing entry for version $EXPECTED_VERSION"
        fi
    fi
}

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --version)
                EXPECTED_VERSION="$2"
                shift 2
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    echo "🚀 Validating release readiness for version $EXPECTED_VERSION"
    echo
    
    check_version_files
    echo
    check_workflows  
    echo
    check_tests
    echo
    check_documentation
    echo
    
    if [[ "$EXIT_CODE" -eq 0 ]]; then
        echo "🎉 Repository appears ready for release!"
        echo "   Run 'git push origin main' to trigger the release workflow"
    else
        echo "💥 Release validation failed. Please fix the issues above."
    fi
    
    exit $EXIT_CODE
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi