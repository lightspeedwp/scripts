
#!/usr/bin/env bats

load test-helper.bash

setup() {
  setup_test_environment
}

teardown() {
  cleanup_test_environment
}

@test "product_dev_project.sh shows usage and exits with missing args" {
  run ../scripts/product_dev_project.sh
  [ "$status" -eq 1 ]
  contains "$output" "Usage:"
}

@test "product_dev_project.sh unknown command returns error" {
  run ../scripts/product_dev_project.sh unknowncmd
  [ "$status" -eq 1 ]
  contains "$output" "Unknown command"
}

@test "product_dev_project.sh dry-run logs for create" {
  export DRY_RUN=true
  run ../scripts/product_dev_project.sh lightspeedwp testproduct
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  contains "$output" "DRY RUN:"
}

@test "product_dev_project.sh link-team missing args" {
  run ../scripts/product_dev_project.sh link-team
  [ "$status" -eq 1 ]
  contains "$output" "Usage: link_team"
}

@test "product_dev_project.sh link-repo missing args" {
  run ../scripts/product_dev_project.sh link-repo
  [ "$status" -eq 1 ]
  contains "$output" "Usage: link_repository"
}

@test "product_dev_project.sh add-draft-issue missing args" {
  run ../scripts/product_dev_project.sh add-draft-issue
  [ "$status" -eq 1 ]
  contains "$output" "Usage: add_draft_issue"
}

@test "product_dev_project.sh update-label missing args" {
  run ../scripts/product_dev_project.sh update-label
  [ "$status" -eq 1 ]
  contains "$output" "Usage: update_label"
}

@test "product_dev_project.sh update-issue-type missing args" {
  run ../scripts/product_dev_project.sh update-issue-type
  [ "$status" -eq 1 ]
  contains "$output" "Usage: update_issue_type"
}
