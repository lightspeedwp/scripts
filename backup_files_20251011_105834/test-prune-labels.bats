#!/usr/bin/env bats

@test "prune-labels.sh runs with no arguments" {
  run ../scripts/prune-labels.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "prune-labels.sh shows help" {
  run ../scripts/prune-labels.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
