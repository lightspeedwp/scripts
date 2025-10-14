#!/usr/bin/env bats
# tests-folder-and-file-readmes.sh
# BATS tests for folder-and-file-readmes.sh

@test "Script exists and is executable" {
  run test -x "$BATS_TEST_DIRNAME/../../../scripts/maintenance/folder-and-file-readmes.sh"
  [ "$status" -eq 0 ]
}

# TODO: Add more tests for dry-run, lint, toc, profile options
