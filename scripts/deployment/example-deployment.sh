#!/bin/bash

# Script Name: example-deployment.sh
# Description: Example deployment script template for LightSpeed WP projects
#
# Version: v0.1.0
# Date: 2025-10-14
# Author: LightSpeedWP
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#
# Usage: ./example-deployment.sh [environment] [version] [options]
#
# Environment:
#  - environment      # Deployment environment (staging, production, development). Default: staging
#
# Version:
#  - version          # Version to deploy (e.g., v1.0.0, latest). Default: latest
#
# Options:
#  --help             # Show this help message
#
# Notes:
#  - Customize this script to fit your deployment needs.
#  - Ensure you have the necessary permissions and configurations for deployment.
#

set -euo pipefail

# Configuration
readonly SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/../logs/deployment.log"

# Default values
ENVIRONMENT="${1:-staging}"
VERSION="${2:-latest}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

# Main deployment function
deploy() {
    local env="$1"
    local version="$2"

    log "Starting deployment to ${env} environment with version ${version}"

    # Add your deployment logic here
    log "Deployment completed successfully"
}

# Error handling
error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

# Validation
validate_environment() {
    case "$ENVIRONMENT" in
        staging|production|development)
            log "Valid environment: $ENVIRONMENT"
            ;;
        *)
            error_exit "Invalid environment: $ENVIRONMENT. Must be staging, production, or development"
            ;;
    esac
}

# Main execution
main() {
    log "=== Deployment Script Started ==="

    validate_environment
    deploy "$ENVIRONMENT" "$VERSION"

    log "=== Deployment Script Completed ==="
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
