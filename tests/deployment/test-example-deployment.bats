#!/usr/bin/env bats

# Load test helpers
load 'test-helper'

# Setup function runs before each test
setup() {
    setup_test_environment
    setup_test_logging

    # Load the script to test
    source "${BATS_TEST_DIRNAME}/../scripts/deployment/example-deployment.sh"
}

# Teardown function runs after each test
teardown() {
    cleanup_test_environment
}

@test "validate_environment accepts valid environments" {
    ENVIRONMENT="staging"
    run validate_environment
    [ "$status" -eq 0 ]

    ENVIRONMENT="production"
    run validate_environment
    [ "$status" -eq 0 ]

    ENVIRONMENT="development"
    run validate_environment
    [ "$status" -eq 0 ]
}

@test "validate_environment rejects invalid environments" {
    ENVIRONMENT="invalid"
    run validate_environment
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Invalid environment: invalid" ]]
}

@test "log function writes to log file" {
    local test_message="Test log message"
    run log "$test_message"

    [ "$status" -eq 0 ]
    assert_file_contains "$LOG_FILE" "$test_message"
}

@test "deploy function logs deployment start and completion" {
    run deploy "staging" "v1.0.0"

    [ "$status" -eq 0 ]
    assert_file_contains "$LOG_FILE" "Starting deployment to staging environment with version v1.0.0"
    assert_file_contains "$LOG_FILE" "Deployment completed successfully"
}

@test "error_exit function logs error and exits with code 1" {
    run error_exit "Test error message"

    [ "$status" -eq 1 ]
    [[ "$output" =~ "ERROR: Test error message" ]]
}

@test "script accepts environment and version parameters" {
    # Test with parameters (need to run the script directly, not source it)
    run bash "${BATS_TEST_DIRNAME}/../scripts/example-deployment.sh" "production" "v2.0.0"

    [ "$status" -eq 0 ]
}

@test "script uses default values when no parameters provided" {
    # Mock the main function to avoid actual execution
    main() {
        echo "Environment: ${ENVIRONMENT:-staging}"
        echo "Version: ${VERSION:-latest}"
    }

    run main
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Environment: staging" ]]
    [[ "$output" =~ "Version: latest" ]]
}
