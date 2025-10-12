#!/bin/bash

# Test runner for update-projects.sh script
# Requires bats-core to be installed

set -euo pipefail  # Exit on error, unset variable, or failed pipe

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ANSI color codes for output formatting
RED='\033[0;31m'    # Red for errors
GREEN='\033[0;32m'  # Green for success
YELLOW='\033[0;33m' # Yellow for warnings/info
BLUE='\033[0;34m'   # Blue for info
NC='\033[0m'        # No Color (reset)

# Info log function: prints informational messages in blue
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Success log function: prints success messages in green
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Error log function: prints error messages in red to stderr
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if bats-core is installed and available in PATH
if ! command -v bats &> /dev/null; then
    log_error "bats is not installed. Please install bats-core first."
    log_info "Visit: https://github.com/bats-core/bats-core"
    log_info "Or install with: git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh ~/.local"
    exit 1
fi

# Announce start of test run
log_info "Running tests for update-projects.sh..."

# Run the Bats test suite for update-projects.sh
# If all tests pass, print success; otherwise, print error and exit with failure
if bats "$SCRIPT_DIR/test-update-projects.bats"; then
    log_success "All tests passed!"
else
    log_error "Some tests failed!"
    exit 1
fi