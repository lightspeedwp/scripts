#!/usr/bin/env bats

@test "run-tests.sh runs with no arguments" {
  run ../scripts/run-tests.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "run-tests.sh shows help" {
  run ../scripts/run-tests.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
