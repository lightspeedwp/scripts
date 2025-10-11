#!/usr/bin/env bats

@test "client-delivery-project.sh runs with no arguments" {
  run ../scripts/client-delivery-project.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "client-delivery-project.sh shows help" {
  run ../scripts/client-delivery-project.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
