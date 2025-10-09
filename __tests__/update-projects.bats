#!/usr/bin/env bats

# This is a minimal Bats test. If you don't have bats installed, run the shell harness instead.

setup() {
  SCRIPTDIR=$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." && pwd)
}

@test "dry run prints expected gh commands for both projects" {
  run "$SCRIPTDIR/update-projects.sh" --dry-run --project-owner testorg --to-project 101 --asnz-project 202
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "DRY RUN: gh project field-create \"101\""
  echo "$output" | grep -q "DRY RUN: gh project field-create \"202\""
}
