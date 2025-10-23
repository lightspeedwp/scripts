#!/bin/bash
###############################################################################
#
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
# Requirements:
#   - bash
#
# Usage: ./example-deployment.sh [environment] [version] [options]
#
# Environment Variables:
#   None
#
# Options:
#  --help             # Show this help message
#
# Examples:
#   ./example-deployment.sh staging v1.0.0
#
# Notes:
#  - Customize this script to fit your deployment needs.
#  - Ensure you have the necessary permissions and configurations for deployment.
#
###############################################################################

set -euo pipefail

# Configuration
readonly SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly LOG_DIR
LOG_DIR="$REPO_ROOT/logs"
readonly LOG_FILE
LOG_FILE="$LOG_DIR/deployment.log"

# Default values
ENVIRONMENT="${1:-staging}"
VERSION="${2:-latest}"

#############################################################################
# Function: log
# Description: Logs a message to the console and a log file.
# Arguments:
#   $* - The message to log.
# Output: Prints the message to stdout and appends it to the log file.
###############################################################################
# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

#############################################################################
# Function: deploy
# Description: The main deployment function.
# Arguments:
#   $1 - The environment to deploy to.
#   $2 - The version to deploy.
# Output: Logs deployment status messages.
###############################################################################
# Main deployment function
deploy() {
    local env="$1"
    local version="$2"

    log "Starting deployment to ${env} environment with version ${version}"

    # Add your deployment logic here
    log "Deployment completed successfully"
}

#############################################################################
# Function: error_exit
# Description: Logs an error message and exits the script.
# Arguments:
#   $1 - The error message.
# Output: Prints the error message to stderr and exits with status 1.
###############################################################################
# Error handling
error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

#############################################################################
# Function: validate_environment
# Description: Validates the deployment environment.
# Arguments:
#   None
# Output: Logs a validation message or an error and exits if invalid.
###############################################################################
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

#############################################################################
# Function: main
# Description: The main execution function of the script.
# Arguments:
#   $@ - The command-line arguments.
# Output: Orchestrates the deployment process.
###############################################################################
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
