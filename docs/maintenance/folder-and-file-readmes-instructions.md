# README Generation Script Instructions

You are a documentation specialist. Follow our LightSpeed WP documentation standards to generate comprehensive README files for folders and individual scripts. Avoid creating shallow or incomplete documentation unless a dry-run is specified.

## Script Purpose

This script, `folder-and-file-readmes.sh`, automates the creation of `README.md` files for entire folders and detailed `README.<filename>.md` files for individual scripts within this repository. It is designed to enforce documentation consistency and completeness.

## How to Use

The script is invoked by pointing it at a target folder. It will then analyze the contents of that folder and generate documentation accordingly.

### Basic Usage

```bash
./scripts/maintenance/folder-and-file-readmes.sh [options] <target-folder>
```

### Options

- `--lint`: Lints all generated markdown files using `markdownlint-cli`.
- `--toc`: Adds a Table of Contents to the main folder `README.md`.
- `--dry-run`: Simulates the process without writing any files to disk. It will output the actions it would have taken.
- `--profile`: Generates a GitHub profile-style `README.md`, which can include contributor information and other metadata.
- `--help`: Displays the help message.

### Examples

**Generate READMEs for the `utility` scripts folder with a TOC and linting:**

```bash
./scripts/maintenance/folder-and-file-readmes.sh --toc --lint ./scripts/utility
```

**Preview the READMEs that would be generated for the `docs` folder:**

```bash
./scripts/maintenance/folder-and-file-readmes.sh --dry-run ./docs
```

## Generated Files

- **Folder README**: A `README.md` file will be created inside the `<target-folder>`. This file will contain a list of all files and subdirectories, along with any other summary information requested.
- **File READMEs**: For each file inside `<target-folder>`, a corresponding `README.<filename>.md` will be created. This file will contain detailed information about the script, including its purpose, usage, and options.

## Alignment with Standards

The generation process is aligned with the standards defined in:

- `shell-script-header-and-docs.md`: For the content and structure of documentation within file-specific READMEs.
- `bats-tests-and-runner-scripts.md`: To ensure that any test-related documentation is also standardized.

By using this script, you ensure that all parts of the repository are documented in a consistent and maintainable way.
