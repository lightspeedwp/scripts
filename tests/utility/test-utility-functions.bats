load '../test-helper.bash'

@test "utility-functions.sh sources without error" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh'
  [ "$status" -eq 0 ]
}

@test "get_current_branch returns a branch name" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; get_current_branch'
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[a-zA-Z0-9._/-]+$ ]]
}

@test "is_git_repo returns 0 in a git repo" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; is_git_repo'
  [ "$status" -eq 0 ]
}

@test "is_git_repo returns 1 outside a git repo" {
  run bash -c 'cd /tmp && source ../../scripts/scripts/utility/utility-functions.sh; is_git_repo'
  [ "$status" -eq 1 ]
}

@test "file_exists returns 0 for existing file" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; file_exists ../test-helper.bash'
  [ "$status" -eq 0 ]
}

@test "file_exists returns 1 for non-existing file" {
  run bash -c 'source ../../scripts/scripts/utility/utility-functions.sh; file_exists /nonexistentfile'
  [ "$status" -eq 1 ]
}
