
# README Generation Script Instructions

You are a documentation specialist. Follow our LightSpeed WP documentation standards to generate comprehensive README files for folders and individual scripts. Avoid creating shallow or incomplete documentation unless a dry-run is specified.

## Script Purpose

The `folder-and-file-readmes.sh` script automates the creation and maintenance of documentation for any folder and its files in the repository. It generates:

- A main `README.md` for the folder, summarizing its purpose, contents, and usage.
- Individual `README.<filename>.md` files for each script or file, documenting their functionality, usage, and metadata.

This ensures every part of the repository is discoverable, understandable, and maintainable.

## Key features

- **Automatic README Generation:** Creates or updates documentation for folders and files, following org-wide standards.
- **Table of Contents:** Optionally inserts a TOC in the main README using `markdown-toc`.
- **Markdown Linting:** Validates all generated markdown files with `markdownlint-cli` for style and consistency.
- **Dry-Run Mode:** Preview changes without writing files, for safe review and CI integration.
- **Profile README:** Generates a GitHub profile-style README with contributor info from git history.
- **File Summarization:** Summarizes file types, shebangs, and key metadata for each file.
- **Badge Integration:** Optionally adds workflow, license, and coverage badges to the main README.
- **Dependency and Import Graphs:** Optionally documents file dependencies and relationships.
- **Customizable Sections:** Supports custom sections (Usage, Installation, API Reference, etc.) via templates or flags.
- **Link Validation:** Optionally checks for broken links in generated documentation.
- **Accessibility Checks:** Optionally runs markdown accessibility checks.
- **Multi-language Support:** Detects and documents files in multiple languages.
- **Update vs. Create:** Optionally updates existing READMEs or only creates new ones.
- **Statistics:** Optionally outputs summary statistics (file count, lines of code, etc.).
- **Hidden/Test File Handling:** Optionally includes/excludes hidden or test files.
- **Author/Contributor Info:** Extracts contributor info from git history for profile and file READMEs.
- **Related Files/Modules:** Optionally links related files or modules in documentation.

## How to use

```bash
./scripts/maintenance/folder-and-file-readmes.sh [options] <target-folder>
```

### Options

- `--lint` Lint markdown output using markdownlint-cli.
- `--toc` Add table of contents to README.md.
- `--dry-run` Show output without writing files.
- `--profile` Generate profile README.
- `--badges` Add workflow/license/coverage badges to README.md.
- `--stats` Output summary statistics for the folder.
- `--validate-links` Check for broken links in generated markdown.
- `--accessibility` Run markdown accessibility checks.
- `--exclude-hidden` Exclude hidden files from documentation.
- `--include-tests` Include test files in documentation.
- `--help` Show help.

### Examples

**Generate READMEs for the `utility` scripts folder with a TOC, badges, and linting:**

```bash
./scripts/maintenance/folder-and-file-readmes.sh --toc --badges --lint ./scripts/utility
```

**Preview the READMEs that would be generated for the `docs` folder:**

```bash
./scripts/maintenance/folder-and-file-readmes.sh --dry-run ./docs
```

**Generate a profile README for the organization root:**

```bash
./scripts/maintenance/folder-and-file-readmes.sh --profile ./
```

## Generated Files

- **Folder README:** `README.md` in the target folder, including:
  - Project/folder description
  - Table of contents (if enabled)
  - List of files and subdirectories
  - Badges (if enabled)
  - Usage and installation instructions
  - Statistics (if enabled)
  - Contributor info (if enabled)
  - Links to related files/modules
  - Accessibility and link validation results (if enabled)
- **File READMEs:** `README.<filename>.md` for each file, including:
  - File type, shebang, and metadata
  - Detailed description and usage
  - Options, environment variables, and examples
  - Author/contributor info
  - API reference or function documentation (for scripts)
  - Dependency/import graph (if enabled)
  - Accessibility and link validation results (if enabled)

## Standards Alignment

- **Shell Script Documentation:** All generated documentation and the script itself must follow the standards in `shell-script-header-and-docs.md`:
  - Full, framed header block with all required fields
  - Inline function documentation for every function
  - No truncation, duplication, or omission of documentation
  - Consistent formatting and indentation
- **Bats Test Standards:** All tests for this script must follow `bats-tests-and-runner-scripts.md`:
  - Standardized test file header
  - Section headers for logical grouping
  - Inline documentation for every test function
  - Coverage summary and usage documentation in `/tests/README.md`
  - Use of `test-helper.bash` for shared logic

## Best Practices

- Always run in dry-run mode before making changes in CI or production.
- Use linting and accessibility checks to ensure documentation quality.
- Regularly update contributor and badge information.
- Document all options, environment variables, and usage patterns.
- Validate links and cross-reference related files for maintainability.

## Notes

- This script is idempotent: running it multiple times will not duplicate documentation.
- All generated documentation is compatible with GitHub rendering and org-wide standards.
- For advanced customization, extend the script with additional flags or templates.

---

By following these instructions and using the script, you ensure that every folder and file in your repository is documented to the highest standards, discoverable by contributors, and maintainable for the long term.
