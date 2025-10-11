#!/usr/bin/env bats

@test "test-dry-run.sh runs with no arguments" {
  run ../scripts/test-dry-run.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "test-dry-run.sh shows help" {
  run ../scripts/test-dry-run.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
