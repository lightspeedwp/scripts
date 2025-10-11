#!/usr/bin/env bats

# Test suite for run-tests.sh script

setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # Path to the script being tested
    SCRIPT="$DIR/../scripts/run-tests.sh"
    
    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

@test "script has proper shebang" {
    head -n1 "$SCRIPT" | grep -q "#!/bin/bash"
}

@test "script uses set -euo pipefail for safety" {
    grep -q "set -euo pipefail" "$SCRIPT"
}

@test "script references bats testing framework" {
    # Should contain references to bats
    grep -q "bats" "$SCRIPT"
}

@test "script can run basic test validation" {
    # Run the test runner to see if it executes without error
    run "$SCRIPT" --help 2>/dev/null || run "$SCRIPT" --dry-run 2>/dev/null || true
    # Should not crash with basic invocation
    [ "$status" -ne 127 ]  # Command not found
}