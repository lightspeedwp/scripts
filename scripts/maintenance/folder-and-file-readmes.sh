#!/usr/bin/env bash
###############################################################################
# Script Name: folder-and-file-readmes.sh
# Description: Generates README.md for a repo folder and README.<filename>.md for each file, extracting header metadata and composing rich documentation. Supports backup, merge, overwrite, lint, TOC, and profile options for automation and compliance.
# Version: v1.0.0
# Date: 2025-10-15
# Author: LightSpeed WP Team
# Github Contributors: @lightspeedwp / @ashleyshaw
# Author URI: https://lightspeedwp.agency/
# License: GPL v3 or later
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
# Requirements:
#   - bash
#   - file
#   - grep
#   - sed
#   - xargs
# Usage:
#   - ./folder-and-file-readmes.sh [options] <target-folder>
#   - ./folder-and-file-readmes.sh --file <file> [--merge|--overwrite]
#   - DRY_RUN=true ./folder-and-file-readmes.sh <target-folder>
# Environment Variables:
#   DRY_RUN        If true, preview changes only
#   MERGE_MODE     If true, merge content
#   OVERWRITE_MODE If true, overwrite content
#   LOG_FILE       Path to log file (optional)
# Options:
#   --help         Show help message
#   --lint         Lint generated markdown files
#   --toc          Add table of contents to README.md
#   --dry-run      Preview changes without writing files
#   --profile      Generate GitHub profile-style README.md
#   --file <file>  Generate README for a specific file
#   --merge        Merge new content with existing README
#   --overwrite    Overwrite existing README
# Examples:
#   ./folder-and-file-readmes.sh scripts/maintenance
#   ./folder-and-file-readmes.sh --file scripts/project/update-projects.sh --merge
#   DRY_RUN=true ./folder-and-file-readmes.sh scripts/utility
#   ./folder-and-file-readmes.sh --lint --toc scripts/maintenance
#   ./folder-and-file-readmes.sh --profile scripts/maintenance
#   ./folder-and-file-readmes.sh --file scripts/maintenance/some-script.sh --overwrite
#   ./folder-and-file-readmes.sh --file scripts/maintenance/some-script.sh --merge
#   ./folder-and-file-readmes.sh --help
# Notes:
#   - All generated files are backed up before overwrite
#   - Follows LightSpeed WP shell script and documentation standards
#   - See README.md for integration, troubleshooting, and customization
#   - Supports automation in CI/CD pipelines
#   - Expand options and features as needed for compliance
###############################################################################

# Strict mode
set -euo pipefail

###############################################################################
# Function: generate_file_readme
# Description: Generates README.<filename>.md for a file, extracting header metadata and composing documentation sections.
# Arguments: $1 - Target file path
# Output: Creates README.<filename>.md in the file's folder (unless DRY_RUN is true). Prints status messages to stdout.
# Notes: Backs up existing README before overwrite. Supports merge and dry-run modes.
###############################################################################
generate_file_readme() {
    local file_path="$1"
    local folder_path
    folder_path="$(dirname "$file_path")"
    local filename
    filename="$(basename "$file_path")"
    local readme_path="$folder_path/README.$filename.md"

    echo "Generating README.$filename.md for file: $filename"

    # Extract shebang and file type
    local shebang
    shebang="$(head -n 1 "$file_path")"
    local file_type
    file_type="$(file -b "$file_path")"

    # Extract header block from script (if present)
    local header_block=""
    local in_header=false
    local header_lines=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^#+ ]]; then
            in_header=true
            header_lines+=("$line")
        elif [[ "$in_header" == true && "$line" =~ ^$ ]]; then
            header_lines+=("")
        elif [[ "$in_header" == true && ! "$line" =~ ^# ]]; then
            break
        fi
    done < "$file_path"
    if [[ ${#header_lines[@]} -gt 0 ]]; then
        header_block=$(printf "%s\n" "${header_lines[@]}")
    fi

    # Parse header fields
    local description usage options examples notes features author version date requirements environment
    description=$(echo "$header_block" | grep -i 'Description:' | sed 's/.*Description:[ ]*//I')
    usage=$(echo "$header_block" | grep -i 'Usage:' | sed 's/.*Usage:[ ]*//I')
    options=$(echo "$header_block" | grep -i 'Options:' | sed 's/.*Options:[ ]*//I')
    examples=$(echo "$header_block" | grep -i 'Examples:' | sed 's/.*Examples:[ ]*//I')
    notes=$(echo "$header_block" | grep -i 'Notes:' | sed 's/.*Notes:[ ]*//I')
    features=$(echo "$header_block" | grep -i 'Features:' | sed 's/.*Features:[ ]*//I')
    author=$(echo "$header_block" | grep -i 'Author:' | sed 's/.*Author:[ ]*//I')
    version=$(echo "$header_block" | grep -i 'Version:' | sed 's/.*Version:[ ]*//I')
    date=$(echo "$header_block" | grep -i 'Date:' | sed 's/.*Date:[ ]*//I')
    requirements=$(echo "$header_block" | grep -i 'Requirements:' | sed 's/.*Requirements:[ ]*//I')
    environment=$(echo "$header_block" | grep -i 'Environment Variables:' | sed 's/.*Environment Variables:[ ]*//I')

    # Compose rich README content
    local content="# $filename\n\n"
    content+="**File Type:** $file_type\n\n"
    if [[ "$shebang" == "#!"* ]]; then
        content+="**Shebang:** $shebang\n\n"
    fi
    if [[ -n "$description" ]]; then
        content+="## Description\n\n$description\n\n"
    fi
    if [[ -n "$features" ]]; then
        content+="## Features\n\n$features\n\n"
    fi
    if [[ -n "$usage" ]]; then
        content+="## Usage\n\n\`$usage\`\n\n"
    fi
    if [[ -n "$options" ]]; then
        content+="## Options\n\n$options\n\n"
    fi
    if [[ -n "$examples" ]]; then
        content+="## Examples\n\n$examples\n\n"
    fi
    if [[ -n "$requirements" ]]; then
        content+="## Requirements\n\n$requirements\n\n"
    fi
    if [[ -n "$environment" ]]; then
        content+="## Environment Variables\n\n$environment\n\n"
    fi
    if [[ -n "$notes" ]]; then
        content+="## Notes\n\n$notes\n\n"
    fi
    content+="## Integration\n\n_This script can be used in automation pipelines and with related scripts in this folder._\n\n"
    content+="## Customization\n\n_You can extend this script by editing its header, options, or integrating with other tools._\n\n"
    content+="---\n\n_Auto-generated by folder-and-file-readmes.sh on $(date)_\n"

    # Backup existing README
    if [[ -f "$readme_path" && "$DRY_RUN" != true ]]; then
        local bak_path
        bak_path="$readme_path.bak.$(date +%Y%m%d%H%M%S)"
        cp "$readme_path" "$bak_path"
        echo "Backup created: $bak_path"
    fi

    # Write or preview README
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would create $readme_path with contents:" >&2
        echo -e "$content"
    else
        if [[ "$MERGE_MODE" == true && -f "$readme_path" ]]; then
            echo -e "$content" >> "$readme_path"
            echo "Merged new content into $readme_path"
        else
            echo -e "$content" > "$readme_path"
            echo "Updated $readme_path"
        fi
    fi
    license="$(echo "$header_block" | grep -i 'license:' | cut -d: -f2-)"

    contributors="$(echo "$header_block" | grep -i 'contributors:' | cut -d: -f2-)"
}

###############################################################################
# Function: parse_arguments
# Description: Parses command line arguments and sets script options.
# Arguments: $@ - Command line arguments
# Output: Sets global variables for script options
# Notes: Validates required parameters and sets merge/overwrite modes.
###############################################################################
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --lint)
                LINT=true
                shift
                ;;
            --toc)
                TOC=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --profile)
                PROFILE=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            --file)
                FILE_MODE=true
                FILE_PATH="$2"
                shift 2
                ;;
            --merge)
                MERGE_MODE=true
                shift
                ;;
            --overwrite)
                OVERWRITE_MODE=true
                shift
                ;;
            *)
                # Assume positional argument is target folder
                if [[ -z "$TARGET_FOLDER" ]]; then
                    TARGET_FOLDER="$1"
                    shift
                else
                    echo "Error: Unknown argument: $1"
                    show_help
                    exit 1
                fi
                ;;
        esac
    done
}

###############################################################################
# Function: main
# Description: Main execution function for the script. Coordinates argument parsing, README generation, and option handling.
# Arguments: $@ - Command line arguments
# Output: Coordinates execution of script functions and prints status messages.
# Notes: Validates input, supports file and folder modes, and handles lint/profile/TOC options.
###############################################################################
main() {
    parse_arguments "$@"
    echo "Arguments parsed successfully."
    echo "LINT: $LINT, TOC: $TOC, DRY_RUN: $DRY_RUN, PROFILE: $PROFILE, TARGET_FOLDER: $TARGET_FOLDER, FILE_MODE: ${FILE_MODE:-false}, FILE_PATH: ${FILE_PATH:-}"

    if [[ "$FILE_MODE" == true ]]; then
        if [[ ! -f "$FILE_PATH" ]]; then
            echo "Error: File does not exist: $FILE_PATH"
            exit 1
        fi
        # Default to overwrite if neither merge nor overwrite specified
        if [[ "$MERGE_MODE" != true && "$OVERWRITE_MODE" != true ]]; then
            OVERWRITE_MODE=true
        fi
        generate_file_readme "$FILE_PATH"
        if [[ "$LINT" == true && "$DRY_RUN" != true ]]; then
            folder_path="$(dirname "$FILE_PATH")"
            filename="$(basename "$FILE_PATH")"
            lint_markdown_files "$folder_path/README.$filename.md"
        fi
        return
    fi

    if [[ -z "$TARGET_FOLDER" ]]; then
        echo "Error: No target folder specified"
        show_help
        exit 1
    fi

    if [[ ! -d "$TARGET_FOLDER" ]]; then
        echo "Error: Target folder does not exist: $TARGET_FOLDER"
        exit 1
    fi

    # Default to overwrite if neither merge nor overwrite specified
    if [[ "$MERGE_MODE" != true && "$OVERWRITE_MODE" != true ]]; then
        OVERWRITE_MODE=true
    fi

    # Generate main README.md for the folder
    generate_folder_readme "$TARGET_FOLDER"

    # If --toc is set, add table of contents to README.md or specified file
    if [[ "$TOC" == true && "$DRY_RUN" != true ]]; then
        # If the argument after --toc is a file, use it directly
        if [[ -n "$TARGET_FOLDER" && -f "$TARGET_FOLDER" ]]; then
            add_table_of_contents "$TARGET_FOLDER"
        else
            add_table_of_contents "$TARGET_FOLDER/README.md"
        fi
    fi

    # Collect generated markdown files for linting
    local markdown_files=()
    markdown_files+=("$TARGET_FOLDER/README.md")

    for file in "$TARGET_FOLDER"/*; do
        # Only process files that are not README.md, README.*.md, or backup files
        local base
        base=$(basename "$file")
        if [[ -f "$file" \
            && "$base" != "README.md" \
            && ! "$base" =~ ^README\..*\.md$ \
            && ! "$base" =~ \.bak\. ]]; then
            # Only update existing README.<filename>.md or create if missing
            local readme_file="$TARGET_FOLDER/README.$base.md"
            if [[ -f "$readme_file" ]]; then
                generate_file_readme "$file"
            else
                generate_file_readme "$file"
            fi
            markdown_files+=("$readme_file")
        fi
    done

    # If --profile is set, generate GitHub profile-style README.md
    if [[ "$PROFILE" == true ]]; then
        generate_profile_readme "$TARGET_FOLDER"
    fi

    # If --lint is set, run markdownlint-cli on all generated markdown files
    if [[ "$LINT" == true && "$DRY_RUN" != true ]]; then
        lint_markdown_files "${markdown_files[@]}"
    fi
}

