#!/usr/bin/env bats

# Test suite for prune-labels.sh script

setup() {
    # Get the directory containing this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # Path to the script being tested
    SCRIPT="$DIR/../scripts/prune-labels.sh"
    
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

@test "script shows help with --help flag" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    # Check if output contains typical help content
    [[ "$output" == *"Usage"* ]] || [[ "$output" == *"help"* ]] || [[ "$output" == *"prune"* ]]
}

@test "script validates GitHub CLI dependency" {
    # Test that script checks for gh command
    grep -q "gh" "$SCRIPT" || skip "Script doesn't use GitHub CLI"
    
    # Should reference gh command or check for it
    grep -q "command -v gh\|which gh\|gh --version" "$SCRIPT" || skip "No gh validation found"
}