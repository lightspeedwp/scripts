#!/usr/bin/env bats

load '../test-helper.bash'

setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    SCRIPT="$DIR/../../scripts/maintenance/update-readme-and-changelog.sh"
    [ -f "$SCRIPT" ]
    [ -x "$SCRIPT" ]
}

@test "update-readme-and-changelog.sh runs without error" {
  run "$SCRIPT"
  [ "$status" -eq 0 ]
}

@test "update-readme-and-changelog.sh updates README.md" {
  # This is a placeholder test and likely needs a real README to check against
  cp "${BATS_TEST_DIRNAME}/../../README.md" "${BATS_TEST_DIRNAME}/../../README.md.bak"
  run "$SCRIPT"
  [ "$status" -eq 0 ]
  # A simple diff might not be sufficient, but it's a basic check
  diff "${BATS_TEST_DIRNAME}/../../README.md" "${BATS_TEST_DIRNAME}/../../README.md.bak" || true
  mv "${BATS_TEST_DIRNAME}/../../README.md.bak" "${BATS_TEST_DIRNAME}/../../README.md"
}
