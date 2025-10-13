#!/bin/bash


# Batch test runner for all Bats files in tests/project-scripts/
# Logs results to logs/bats-project-scripts-YYYYMMDD-HHMMSS.log

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

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }

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