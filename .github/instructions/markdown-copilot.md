# Markdown Copilot Instructions

You are a documentation contributor working on LightSpeed WP automation documentation. Follow our markdown standards and accessibility guidelines to create clear, maintainable documentation. Avoid technical jargon without explanation unless specified.

## Documentation Standards

### File Structure
```markdown
# Document Title

Brief description of the document's purpose and scope.

## Table of Contents (for long documents)
- [Section 1](#section-1)
- [Section 2](#section-2)

## Section Structure
Use consistent heading hierarchy and clear section organization.
```

### Heading Guidelines
- Use sentence case for headings: "Getting started" not "Getting Started"  
- Use descriptive, scannable headings
- Maintain consistent hierarchy (H1 → H2 → H3)
- Include anchor links for navigation in long documents

### Code Documentation
```markdown
## Code Examples

Provide context before code blocks:

```bash
# Install dependencies
npm install

# Run tests  
npm test
```

Include expected output when helpful:
```bash
$ ./script-name.sh --help
Usage: ./script-name.sh [options] [arguments]
Options:
  -h, --help     Show this help message
  --dry-run      Show what would be done without executing
```
```

### Link Standards
- Use relative links for internal files: `[Contributing](../CONTRIBUTING.md)`
- Include descriptive link text: "See the [deployment guide](./deploy.md)" not "click here"
- Verify all links work and update them when files move

### Accessibility Guidelines

#### Alt Text for Images
```markdown
![Screenshot showing the GitHub Actions workflow configuration interface](./images/github-actions-config.png)
```

#### Table Structure
```markdown
| Column Header | Description | Required |
|---------------|-------------|----------|
| `script_name` | Name of the automation script | Yes |
| `description` | Brief description of functionality | Yes |
| `test_file`   | Path to corresponding test file | Yes |
```

#### Lists and Navigation
- Use ordered lists for sequential steps
- Use unordered lists for non-sequential items
- Include clear navigation cues in long documents

## Content Guidelines

### Writing Style
- Use active voice: "Run the script" not "The script should be run"
- Write in second person: "You can configure..." 
- Use present tense for current functionality
- Keep sentences concise and scannable

### Technical Accuracy
- Test all code examples before including them
- Keep examples current with latest versions
- Include version information when relevant
- Provide troubleshooting for common issues

### User Focus
```markdown
## Quick Start

For new contributors who want to add a shell script:

1. Create your script in `/scripts/` following kebab-case naming
2. Add comprehensive tests in `/tests/test-your-script.bats`
3. Update relevant README files
4. Submit a pull request using our template

**Need help?** Check our [troubleshooting guide](./TROUBLESHOOTING.md) or create an issue.
```

## Repository-Specific Patterns

### README Structure
```markdown
# Repository Name

Brief description and purpose.

## Quick Start
Fastest path to getting up and running.

## Installation  
Detailed setup instructions.

## Usage
Common use cases and examples.

## Contributing
Link to CONTRIBUTING.md with brief overview.

## License
License information and link.
```

### API Documentation
```markdown
## Script Reference

### script-name.sh

**Description**: Brief description of functionality

**Usage**: `./script-name.sh [options] [arguments]`

**Parameters**:
- `--dry-run`: Preview changes without executing
- `--verbose`: Show detailed output
- `--help`: Display help information

**Examples**:
```bash
# Basic usage
./script-name.sh config.json

# Preview mode  
./script-name.sh --dry-run config.json
```

**Exit Codes**:
- `0`: Success
- `1`: Invalid arguments
- `2`: Configuration error
```

### Changelog Format
```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New automation script for deployment validation

### Changed  
- Improved error handling in sync-labels.sh

### Fixed
- Resolved issue with GitHub API rate limiting

## [1.2.0] - 2024-01-15

### Added
- Support for custom label configurations
```

## Integration with Development Workflow

### PR Documentation
- Include clear description of changes in README updates
- Add screenshots for UI-related documentation  
- Link to related issues and discussions
- Update table of contents when adding sections

### Issue Templates
```markdown
## Documentation Issue Template

**Type**: [Bug in docs / Missing docs / Outdated info / Enhancement]

**Location**: [Specific file and section]

**Description**: 
Clear description of the issue or missing information.

**Suggested Solution**:
What should be added, changed, or fixed.

**Additional Context**:
Screenshots, links, or other relevant information.
```

### Review Guidelines
- Check for broken internal links
- Verify code examples execute correctly  
- Ensure screenshots are current and accessible
- Validate that new documentation follows established patterns
- Test installation/usage instructions from scratch

## Cross-References

### Internal Documentation
- Reference other organization repos when relevant
- Link to the LightSpeed Automation & Governance Handbook for workflow documentation
- Cross-reference related scripts and workflows
- Maintain bidirectional links between related documents

### External Resources
- Link to official documentation for tools and services
- Include version-specific links when possible
- Provide backup links for critical external resources
- Regularly audit and update external links