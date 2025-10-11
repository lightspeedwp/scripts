#!/usr/bin/env bats

@test "prune-labels.sh.new runs with no arguments" {
  run ../scripts/prune-labels.sh.new
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "prune-labels.sh.new shows help" {
  run ../scripts/prune-labels.sh.new --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
