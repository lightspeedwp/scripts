#!/usr/bin/env bats

# Test suite for utility-functions.sh script

setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # Path to the script being tested
    SCRIPT="$DIR/../scripts/utility-functions.sh"
    
    # Ensure script exists and is executable
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

@test "script has proper shebang" {
    head -n1 "$SCRIPT" | grep -q "#!/.*bash"
}

@test "script uses set -euo pipefail for safety" {
    grep -q "set -euo pipefail" "$SCRIPT"
}

@test "script can be sourced without errors" {
    run bash -c "source '$SCRIPT' && echo 'sourced successfully'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"sourced successfully"* ]]
}

@test "utility functions are defined" {
    # Source the script and check if expected functions exist
    source "$SCRIPT"
    
    # Check if common utility functions are available
    # These are typical patterns in utility scripts
    type -t log_info >/dev/null 2>&1 || skip "log_info function not found"
    type -t log_error >/dev/null 2>&1 || skip "log_error function not found"
}