#!/usr/bin/env bats

load 'test_helper'

setup() {
    # Create a temporary directory for testing
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
}

teardown() {
    cd -
    rm -rf "$TMP_DIR"
}

@test "folder-and-file-readmes.sh: shows help message" {
    run "${BATS_TEST_DIRNAME}/../../scripts/maintenance/folder-and-file-readmes.sh" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "folder-and-file-readmes.sh: handles no target folder" {
    run "${BATS_TEST_DIRNAME}/../../scripts/maintenance/folder-and-file-readmes.sh"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error: No target folder specified" ]]
}

@test "folder-and-file-readmes.sh: handles non-existent target folder" {
    run "${BATS_TEST_DIRNAME}/../../scripts/maintenance/folder-and-file-readmes.sh" "non-existent-folder"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error: Target folder does not exist" ]]
}

@test "folder-and-file-readmes.sh: dry-run creates no files" {
    mkdir -p "test-folder"
    touch "test-folder/file1.sh"
    run "${BATS_TEST_DIRNAME}/../../scripts/maintenance/folder-and-file-readmes.sh" --dry-run "test-folder"
    [ "$status" -eq 0 ]
    [ ! -f "test-folder/README.md" ]
    [ ! -f "test-folder/README.file1.sh.md" ]
    [[ "$output" =~ "[DRY RUN]" ]]
}

# Add more tests here for each feature as it's implemented.
