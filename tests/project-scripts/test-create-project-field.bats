#!/usr/bin/env bats

@test "test-create-project-field.sh runs with no arguments" {
  run ../../scripts/project/test-create-project-field.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "test-create-project-field.sh shows help" {
  run ../../scripts/project/test-create-project-field.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
