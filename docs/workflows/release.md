# Workflow: release.yml

## Purpose

Automates the release process: version bump, changelog compilation, tagging, and GitHub Release creation.

## Triggers

- On push to main
- Manual workflow dispatch

## Key Steps

- Validates changelog and version
- Compiles changelog
- Tags release
- Creates GitHub Release
- Updates badges and documentation

## Related Files

- `.github/workflows/release.yml`
