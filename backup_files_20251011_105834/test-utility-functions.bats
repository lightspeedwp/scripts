#!/usr/bin/env bats

@test "utility-functions.sh runs with no arguments" {
  run ../scripts/utility-functions.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "utility-functions.sh shows help" {
  run ../scripts/utility-functions.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
