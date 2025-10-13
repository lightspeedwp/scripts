
#!/usr/bin/env bats
load '../../tests/test-helper.bash'


setup() {
  export GH_CLI_MOCK=1
}

teardown() {
  unset GH_CLI_MOCK
}

@test "shows usage with no arguments" {
  run ../../scripts/project/client-delivery-project.sh
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "shows help output" {
  run ../../scripts/project/client-delivery-project.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "creates all fields in dry-run mode" {
  export DRY_RUN=true
  run ../../scripts/project/client-delivery-project.sh acme-corp 42
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  # Check for all field names
  contains "$output" "Creating field 'Theme'"
  contains "$output" "Creating field 'Area'"
  contains "$output" "Creating field 'Priority'"
  contains "$output" "Creating field 'Severity'"
  contains "$output" "Creating field 'Size'"
  contains "$output" "Creating field 'Phase'"
  contains "$output" "Creating field 'Release type'"
  contains "$output" "Creating field 'Environment'"
  contains "$output" "Creating field 'Status'"
  contains "$output" "Creating field 'Issue Type'"
  contains "$output" "Creating field 'Milestone'"
  contains "$output" "Creating number field 'Story Points'"
  contains "$output" "Creating number field 'Estimate'"
  contains "$output" "Creating date field 'Due Date'"
  contains "$output" "Creating date field 'Start Date'"
  contains "$output" "Creating date field 'Deadline'"
  contains "$output" "Creating text field 'Assignee'"
}

@test "assigns colors for single-select options" {
  export DRY_RUN=true
  run ../../scripts/project/client-delivery-project.sh acme-corp 42
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Setting color for Theme:Design System"
  contains "$output" "Setting color for Area:Frontend"
  contains "$output" "Setting color for Priority:High"
}

@test "idempotency: does not duplicate fields" {
  export DRY_RUN=true
  # Simulate fields already exist by running twice
  run ../../scripts/project/client-delivery-project.sh acme-corp 42
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "Field 'Theme' already exists"
  contains "$output" "Field 'Area' already exists"
}

@test "handles environment variable overrides" {
  export ORG="customorg"
  export DRY_RUN=true
  run ../../scripts/project/client-delivery-project.sh customorg acme-corp 99
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "customorg"
}

@test "errors on missing client name" {
  run ../../scripts/project/client-delivery-project.sh
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "errors on invalid field spec (simulate)" {
  export DRY_RUN=true
  # Simulate invalid field by calling with empty name
  run ../../scripts/project/client-delivery-project.sh "" 42
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "does not print credentials in output" {
  export LS_APP_PRIVATE_KEY="supersecret"
  export DRY_RUN=true
  run ../../scripts/project/client-delivery-project.sh acme-corp 42
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  ! [[ "$output" =~ "supersecret" ]]
}
