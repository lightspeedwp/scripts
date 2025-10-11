#!/usr/bin/env bats

# Test: start-mcp-server.sh
# Description: Ensures the Playwright MCP server script starts the server and handles already-running state

setup() {
  export TEST_LOG="test-playwright-mcp-server.log"
  export MCP_CMD="echo 'MCP server started'"
  export MCP_LOG="$TEST_LOG"
  export SCRIPT="$(dirname "$BATS_TEST_FILENAME")/../scripts/start-mcp-server.sh"
}

teardown() {
  rm -f "$TEST_LOG"
}

@test "starts MCP server when not running" {
  pkill -f "MCP server started" || true
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  grep "MCP server started" "$TEST_LOG"
}

@test "does not start MCP server if already running" {
  # Simulate MCP server running
  bash -c "$MCP_CMD" &
  sleep 1
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  grep "already running" "$output"
}
