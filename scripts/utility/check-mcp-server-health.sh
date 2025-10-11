#!/bin/bash
# Script Name: check-mcp-server-health.sh
# Description: Checks MCP server health and restarts if not running
# Usage: ./check-mcp-server-health.sh
# Author: LightSpeed WP Team
# Date: 2025-10-11

set -euo pipefail

MCP_SERVER_URL="http://localhost:3000/health"
RESTART_SCRIPT="$(dirname "$0")/start-mcp-server.sh"

function log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*"
}
function log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" >&2
}

function check_health() {
    log_info "Checking MCP server health at $MCP_SERVER_URL"
    if curl -fsS "$MCP_SERVER_URL" | grep -q 'healthy'; then
        log_info "MCP server is healthy."
        return 0
    else
        log_error "MCP server is not healthy. Attempting restart."
        "$RESTART_SCRIPT"
        sleep 5
        if curl -fsS "$MCP_SERVER_URL" | grep -q 'healthy'; then
            log_info "MCP server restarted and is now healthy."
            return 0
        else
            log_error "Failed to restart MCP server."
            return 1
        fi
    fi
}

check_health
