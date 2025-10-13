#!/usr/bin/env bats
load '../../tests/test-helper.bash'

setup() {
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
}

@test "errors if gh CLI is not installed" {
  PATH="/nonexistent:$PATH"
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  [[ "$output" =~ "GitHub CLI (gh) is not installed" ]]
}

@test "errors if not authenticated with gh CLI" {
  export GH_AUTH_FAIL=1
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  [[ "$output" =~ "GitHub CLI is not authenticated" ]]
}

@test "errors if required scopes are missing" {
  export GH_SCOPES="read:user"
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Missing required GitHub CLI scopes" ]]
}

@test "succeeds if authenticated and all scopes present" {
  export GH_AUTH_OK=1
  export GH_SCOPES="repo,project,read:org,read:user"
  run ../../scripts/project/product-dev-project.sh lightspeedwp testproduct 99
  [ "$status" -eq 0 ]
  [[ "$output" =~ "GitHub CLI is authenticated" ]]
  [[ "$output" =~ "All required scopes are present" ]]
}
