#!/bin/bash
# start-mcp-server.sh
# Ensures Playwright MCP server is running, restarts if stopped

set -e

MCP_CMD="npx playwright mcp-server"
MCP_LOG="playwright-mcp-server.log"

# Check if MCP server is running
if pgrep -f "playwright mcp-server" > /dev/null; then
  echo "Playwright MCP server is already running."
else
  echo "Starting Playwright MCP server..."
  nohup $MCP_CMD > "$MCP_LOG" 2>&1 &
  sleep 2
  if pgrep -f "playwright mcp-server" > /dev/null; then
    echo "Playwright MCP server started successfully."
  else
    echo "Failed to start Playwright MCP server."
    exit 1
  fi
fi

# Optionally: Add restart logic if server stops
# This can be extended with a process manager (e.g., PM2) for production use
