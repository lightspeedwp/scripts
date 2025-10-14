#!/bin/bash

# Script Name: run-tests.sh
# Description: Batch test runner for project script Bats tests
# Usage: ./run-tests.sh
# Author: LightSpeed WP Team
# Date: 2025-10-14
#
# This script runs all Bats test files in the tests/project-scripts/ directory
# and logs the results to a timestamped file in the logs directory.
#
# Requirements:
#   - bats-core installed and in PATH
#   - Appropriate project script test files in tests/project-scripts/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$REPO_ROOT/logs"
LOG_FILE="$LOG_DIR/bats-project-scripts-$(date +%Y%m%d-%H%M%S).log"
TEST_DIR="$REPO_ROOT/tests/project-scripts"

mkdir -p "$LOG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function: log_info
# Description: Prints an informational message with blue [INFO] prefix
# Args: $1 - The message to print
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Function: log_success
# Description: Prints a success message with green [SUCCESS] prefix
# Args: $1 - The message to print
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Function: log_error
# Description: Prints an error message with red [ERROR] prefix to stderr
# Args: $1 - The message to print
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

if ! command -v bats &> /dev/null; then
    log_error "bats is not installed. Please install bats-core first."
    exit 1
fi

log_info "Running all Bats tests in $TEST_DIR..."
for test in "$TEST_DIR"/*.bats; do
    log_info "Running $test..."
    bats "$test" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
done

log_success "All test results are logged in $LOG_FILE"