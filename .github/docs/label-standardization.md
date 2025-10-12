# Label Standardization Guide

This repository enforces organization-wide label standards to maintain consistency across all repositories.

## Standard Label Prefixes

All standardized labels follow these prefixing patterns:

- `lang:` - Programming language identifiers (e.g., `lang:php`, `lang:js`, `lang:css`)
- `area:` - Project areas (e.g., `area:documentation`, `area:security`, `area:performance`)
- `status:` - Work status identifiers (e.g., `status:needs-review`, `status:in-progress`)
- `priority:` - Priority levels (e.g., `priority:high`, `priority:low`)
- `size:` - Work size estimation (e.g., `size:small`, `size:medium`, `size:large`)

## Preventing Label Duplication

To prevent duplicate labels like `php` when we already have `lang:php`:

1. All labeler configurations use the standard prefixed versions
2. The `prune-labels.sh` script automatically migrates non-standard labels to their standard versions
3. A weekly GitHub Action enforces these standards organization-wide

## Manual Enforcement

To manually enforce label standards on a repository:

```bash
# Dry run to see what would happen
DRY_RUN=true ./scripts/prune-labels.sh

# Actually enforce standards (with migration, not deletion)
DRY_RUN=false ./scripts/prune-labels.sh

# Strictly enforce (delete non-standard labels without migration)
DRY_RUN=false STRICT_PRUNE=true ./scripts/prune-labels.sh

# Only target a specific repository
DRY_RUN=true ONLY="repository-name" ./scripts/prune-labels.sh
```

## Integration with Other Workflows

The standardized labels are integrated with:

- Pull request automation
- Issue type assignment
- Project status tracking
- Release management

For the complete list of organization-wide standard labels, see the [org-wide-labels-v1-11.md](https://github.com/lightspeedwp/.github/blob/main/org-wide-labels-v1-11.md) document.
