#!/usr/bin/env bats

@test "sync-org-labels.sh runs with no arguments" {
  run ../scripts/sync-org-labels.sh
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "sync-org-labels.sh shows help" {
  run ../scripts/sync-org-labels.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "help" || "$output" =~ "usage" ]]
}
