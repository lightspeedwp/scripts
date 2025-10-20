---
applyTo: '**'
description: 'Release and changelog automation standards for LightSpeed WP. Covers changelog enforcement, compilation, versioning, and release workflows.'

---

# Release and Changelog Automation Instructions

You are a release automation specialist. Follow these standards to enforce changelog entries, automate changelog compilation, and manage versioned releases for LightSpeed WP projects.

## Changelog Enforcement on PRs
- **Every PR must include a changelog entry** under the `Unreleased` section in `CHANGELOG.md` (Keep a Changelog format).
- Use a GitHub Action (e.g., `dangoslen/changelog-enforcer`) to block PRs that do not update the changelog, unless `[skip changelog]` label or comment is present.
- Changelog entries must:
  - Start with a dash (`-`)
  - Include a category prefix (e.g., `**Added:**`, `**Fixed:**`, `**Changed:**`)
  - Be concise and user-facing
- Example:
  ```markdown
  ## [Unreleased]
  - **Fixed:** Correct calculation for order totals.
  ```
- Allow maintainers to bypass with `[skip changelog]` label/comment for non-user-facing changes.

## Compiling Changelogs on Release
- On release (merge to `main` or workflow dispatch):
  - Validate that `Unreleased` has entries; abort if empty.
  - Use a changelog action (e.g., `release-flow/keep-a-changelog-action`) or script to:
    - Convert `Unreleased` to a new version section with version/date
    - Add a fresh `Unreleased` header
    - Group entries under `Added`, `Fixed`, `Changed`, etc.
  - Commit the updated `CHANGELOG.md` and bump version in code/files as needed.

## Release Process Automation
- Trigger release workflow on merge to `main` or manual dispatch.
- Steps:
  1. Validate changelog and version consistency
  2. Build/package artifacts (if needed)
  3. Tag the release (e.g., `v1.2.3`)
  4. Create a GitHub Release with notes from the changelog
  5. Attach build artifacts (if any)
  6. Post-release: update stable tags, notify, or deploy as needed
- All steps must be reproducible and not rely on local developer environments.

## Review Checklist
- [ ] PRs require changelog entry or `[skip changelog]` label/comment
- [ ] Changelog entries follow format and are grouped by category
- [ ] Release workflow validates changelog, version, and documentation
- [ ] Release workflow tags, creates release, and attaches artifacts
- [ ] All automation is auditable and uses GitHub Actions/secrets

---

See also: [release.yml](../workflows/release.yml), [validate-release.sh](../../scripts/utility/validate-release.sh), [validate-changelog-links.sh](../../scripts/maintenance/validate-changelog-links.sh)
