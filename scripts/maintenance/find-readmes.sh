
#!/bin/bash
#
# Script Name: find-readmes.sh
# Description: Finds all README files in the repository.
# Usage: ./find-readmes.sh
# Author: LightSpeed WP Team
# Date: 2025-10-12
#
set -euo pipefail

# Find all README files in the repo
find . -type f -iname 'README*.md'
