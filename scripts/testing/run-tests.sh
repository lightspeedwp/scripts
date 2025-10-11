#!/bin/bash
# Test runner for update-projects.sh script
# Requires bats-core to be installed
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if bats is available
if ! command -v bats &> /dev/null; then
    log_error "bats is not installed. Please install bats-core first."
    log_info "Visit: https://github.com/bats-core/bats-core"
    log_info "Or install with: git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh ~/.local"
    exit 1
fi

log_info "Running tests for update-projects.sh..."

# Run the tests
if bats "$SCRIPT_DIR/test-update-projects.bats"; then
    log_success "All tests passed!"
else
    log_error "Some tests failed!"
    exit 1
fi