#!/bin/bash
#
# Script Name: example-deployment.sh
# Description: Example deployment script template for LightSpeed WP projects
# Usage: ./example-deployment.sh [environment] [version]
# Author: LightSpeed WP Team
# Date: 2024-01-01
#

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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