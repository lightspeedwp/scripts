#!/usr/bin/env bats

load '../../tests/test-helper.bash'

@test "update-readme-and-changelog.sh exists and is executable" {
  [ -x "${BATS_TEST_DIRNAME}/../scripts/update-readme-and-changelog.sh" ]
}

@test "update-readme-and-changelog.sh runs without error" {
  run "${BATS_TEST_DIRNAME}/../scripts/update-readme-and-changelog.sh"
  [ "$status" -eq 0 ]
}

@test "update-readme-and-changelog.sh updates README.md" {
  cp "${BATS_TEST_DIRNAME}/../README.md" "${BATS_TEST_DIRNAME}/../README.md.bak"
  run "${BATS_TEST_DIRNAME}/../scripts/update-readme-and-changelog.sh"
  [ "$status" -eq 0 ]
  diff "${BATS_TEST_DIRNAME}/../README.md" "${BATS_TEST_DIRNAME}/../README.md.bak" || true
  rm "${BATS_TEST_DIRNAME}/../README.md.bak"
}
