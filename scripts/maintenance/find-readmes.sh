#!/bin/bash
set -euo pipefail

# Find all README files in the repo
find . -type f -iname 'README*.md'
