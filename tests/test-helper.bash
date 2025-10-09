#!/usr/bin/env bash
#
# Test helper functions for Bats tests
# This file provides common utilities used across test files
#

# Setup test environment
setup_test_environment() {
    export TEST_TEMP_DIR="/tmp/lightspeedwp-test-$$"
    mkdir -p "$TEST_TEMP_DIR"
    export PATH="${BATS_TEST_DIRNAME}/../scripts:$PATH"
}

# Cleanup test environment
cleanup_test_environment() {
    if [ -d "$TEST_TEMP_DIR" ]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# Create a temporary file with content
create_temp_file() {
    local content="$1"
    local filename="${2:-test-file}"
    local temp_file="${TEST_TEMP_DIR}/${filename}"
    
    echo "$content" > "$temp_file"
    echo "$temp_file"
}

# Mock a command by creating a temporary script in PATH
mock_command() {
    local command_name="$1"
    local mock_behavior="$2"
    local mock_script="${TEST_TEMP_DIR}/mock-${command_name}"
    
    cat << EOF > "$mock_script"
#!/bin/bash
$mock_behavior
EOF
    
    chmod +x "$mock_script"
    export PATH="${TEST_TEMP_DIR}:$PATH"
}

# Check if a string contains another string
contains() {
    local haystack="$1"
    local needle="$2"
    [[ "$haystack" == *"$needle"* ]]
}

# Verify file exists and has expected content
assert_file_contains() {
    local file="$1"
    local expected_content="$2"
    
    [ -f "$file" ] || {
        echo "File $file does not exist"
        return 1
    }
    
    grep -q "$expected_content" "$file" || {
        echo "File $file does not contain expected content: $expected_content"
        echo "Actual content:"
        cat "$file"
        return 1
    }
}

# Verify command exists and is executable
assert_command_exists() {
    local command="$1"
    command -v "$command" >/dev/null 2>&1 || {
        echo "Command '$command' not found"
        return 1
    }
}

# Set up logging for tests
setup_test_logging() {
    export LOG_FILE="${TEST_TEMP_DIR}/test.log"
    touch "$LOG_FILE"
}

# Get the last log entry
get_last_log_entry() {
    tail -n 1 "$LOG_FILE" 2>/dev/null || echo ""
}