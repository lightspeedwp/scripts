# Changelog

All notable changes to the LightSpeed WP automation scripts repository will be documented in this file.
All notable changes to this repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Fixed
### Changed
### Security
### Fixed

---

## [v0.1.0]
### Initial Repository Setup
- Basic shell script automation framework
- GitHub Actions workflow templates  
- Bats testing infrastructure
- Initial documentation and contribution guidelines
- MCP configuration for VSCode integration

### Added
- Expanded documentation for org-wide branching, label governance, changelog enforcement, release automation, project templates, and contributor experience.
- README and all governance docs updated to reference new Copilot instructions, contributor types, prompt library, and chatmodes.
- GitHub Copilot custom instructions and role-based guidance system
- Comprehensive contributor type instructions for different development roles
- Shell script, JavaScript, Python, and Markdown Copilot instruction files
- Reusable prompt templates for Copilot Chat and CLI interactions
- Scenario-based chat modes for different development contexts
- Enhanced README with Copilot integration and workflow documentation
- Governance files: LICENSE, CODE_OF_CONDUCT, SECURITY, SUPPORT, DEVELOPMENT
- All-contributors configuration for community recognition
- Bootstrap of org-wide LightSpeedWP automation repository with handbook, shell scripts, workflows, and templates.
- Initial implementation of changelog, label, and release automation for client and product projects.
- Rollout of project templates for Product Development and Client Delivery boards.
- Copilot custom instructions (.github/custom-instructions.md) with table of contents for contributor types, prompts, chatmodes, and language guides.
- Contributor docs: .all-contributorsrc, .all-contributorsrc-docs.md.
- Governance files: LICENSE (GNU3), DEVELOPMENT.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, SUPPORT.md.
- All Copilot instructions written as: "You are a [role]. Follow our [framework/patterns] to [type of task]. Avoid [practices or tools] unless specified."
- All files and subfolders referenced in .github/custom-instructions.md with short explanations.
- Updated README to reflect new repo structure and Copilot instructions integration.

### Changed
- Updated repository structure documentation to reflect Copilot instructions
- Enhanced .github directory with comprehensive AI assistance configuration
- Improved CONTRIBUTING.md with detailed workflow integration
- Aligned all documentation with LightSpeed role-based framework

### Security
- Added security reporting guidelines and vulnerability disclosure process
- Implemented secrets management best practices in instruction files
- Enhanced security review prompts and guidelines

### Fixed
- Resolved missing contributors, governance, and support documentation.
- Improved consistency in changelog enforcement and branch/label mapping.

---

## Release Process

This repository follows semantic versioning with automated changelog generation:

- **Major versions** (x.0.0): Breaking changes to automation scripts or workflows
- **Minor versions** (x.y.0): New features, scripts, or significant enhancements  
- **Patch versions** (x.y.z): Bug fixes, documentation updates, and minor improvements

### Automated Release Management

Releases are managed through GitHub Actions with:
- Automated changelog generation from conventional commits
- Version bumping based on commit types (feat, fix, docs, etc.)
- Integration with GitHub Projects and milestone tracking
- Notification to relevant teams and stakeholders

### Manual Release Process

For manual releases:

1. **Prepare Release**:
   ```bash
   # Update version in relevant files
   # Review and update CHANGELOG.md
   git add .
   git commit -m "chore: prepare release v1.x.x"
   ```

2. **Create Release**:
   ```bash
   git tag -a v1.x.x -m "Release v1.x.x"
   git push origin v1.x.x
   ```

3. **Post-Release**:
   - Update GitHub release notes
   - Notify organization channels
   - Update dependent repositories if needed

### Breaking Change Communication

When releasing breaking changes:

1. **Advance Notice**: Communicate changes in organization channels
2. **Migration Guide**: Provide clear upgrade instructions  
3. **Deprecation Period**: Maintain backward compatibility when possible
4. **Support**: Offer assistance during transition period

---

*This changelog is automatically updated by our release automation. For detailed commit history, see the [Git log](https://github.com/lightspeedwp/scripts/commits).*
---
