# Pull Request

## Changelog Entry (Required)


Please add a changelog entry for this PR. Use the following format:

```md
### Added
- Short description of new features or scripts

### Changed
- Short description of changes or improvements

### Fixed
- Short description of bug fixes

### Security
- Short description of security updates
```

Refer to [CHANGELOG.md](../CHANGELOG.md) for examples. Changelog entries are required for all PRs and will be included in the automated release process.

> **Note:** Releases are automated when merging from `develop` to `main`. See [release automation workflow](../.github/workflows/release.yml).

## Description

Brief description of changes made and why.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Script refactoring

## Files Changed

- **Scripts**: List any scripts added/modified
- **Workflows**: List any workflows added/modified
- **Tests**: List any tests added/modified
- **Documentation**: List any docs updated

## Testing

- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] I have run the existing test suite and all tests pass
- [ ] I have tested the script/workflow manually

### Test Commands Run

```bash
# List the commands you ran to test
bats tests/test-script-name.bats
./scripts/script-name.sh --dry-run
```

## Checklist

- [ ] My code follows the kebab-case naming convention
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code where necessary
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] I have reviewed the changelog entry for this PR (see [CHANGELOG.md](../CHANGELOG.md))
- [ ] I understand changelog updates are automated on PR merge (see [changelog automation workflow](../.github/workflows/changelog.yml))

## Screenshots (if applicable)

Add screenshots to help explain your changes.

## Additional Notes

Any additional information that reviewers should know.
