#!/usr/bin/env bats

@test "find-readmes.sh lists all README files" {
  run scripts/maintenance/find-readmes.sh
  [ "$status" -eq 0 ]
  [[ "$output" =~ "README.md" ]]
}
