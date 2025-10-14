#!/usr/bin/env bats
load '../../tests/test-helper.bash'

setup() {
  export GH_CLI_MOCK=1
  export DRY_RUN=true
}

teardown() {
  unset GH_CLI_MOCK
  unset DRY_RUN
}


@test "validates importing settings CSV and dry-run output (no access)" {
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42 --settings-file ../../scripts/project/fixtures/client-delivery-settings.csv
  [ "$status" -eq 0 ]
  contains "$output" "Updating project name to 'Client Delivery Project'"
  contains "$output" "Updating short description to 'Project for managing client delivery engagements'"
  contains "$output" "Updating README for project #42"
  # Should NOT contain access management lines
  not_contains "$output" "Setting base role"
  not_contains "$output" "Inviting"
}


@test "validates importing settings CSV and dry-run output (with access)" {
  run ../../scripts/project/client-delivery-project.sh lightspeedwp acme-corp 42 --settings-file ../../scripts/project/fixtures/client-delivery-settings.csv --access-file ../../scripts/project/fixtures/client-delivery-manage-access.csv --manage-access
  [ "$status" -eq 0 ]
  contains "$output" "Setting base role to 'Write'"
  contains "$output" "Inviting Interns with role: Write"
  contains "$output" "Inviting Developers with role: Write"
  contains "$output" "Inviting ashleyshaw with role: Write"
}
