#!/usr/bin/env node
/**
 * Labeling Agent
 * 
 * You are a project organization specialist. Follow our LightSpeed WP labeling standards 
 * to ensure consistent issue and PR categorization. Avoid non-standard labels 
 * unless specified.
 * 
 * This agent manages comprehensive labeling automation:
 * 1. Automatically applies labels based on content, files changed, and context
 * 2. Enforces label consistency and naming conventions
 * 3. Manages label hierarchies and relationships
 * 4. Integrates with project management and workflow automation
 * 
 * Usage:
 * - Automatically triggered on issue/PR creation and updates
 * - Validates label consistency during repository management
 * 
 * Environment Variables:
 * - GITHUB_TOKEN: Required for API access
 * - DRY_RUN: Set to "true" to preview without making changes
 * - VERBOSE: Set to "true" for detailed logs
 * - LABEL_CONFIG_PATH: Path to label configuration file (default: .github/labels.yml)
 * - AUTO_REMOVE_INVALID: Set to "true" to automatically remove non-standard labels
 */

const minimatch = require('minimatch');

// Label taxonomy
const LABEL_FAMILIES = {
  lang: { /* ... */ },
  type: {
    prefix: 'type:',
    description: 'Type of change or issue',
    color: 'B60205',
    labels: ['bug', 'feature', 'enhancement', 'refactor', 'documentation', 'chore', 'question', 'breaking-change'],
  },
  area: {
    prefix: 'area:',
    description: 'Functional area or component',
    color: '1D76DB',
    labels: ['ci', 'documentation', 'testing', 'security', 'dependencies', 'performance'],
  },
  // ... other families ...
};
// Alias for compatibility
const LABEL_CATEGORIES = LABEL_FAMILIES;

// Update all references to use LABEL_FAMILIES
function findStandardLabel(input) {
  const normalized = input.toLowerCase().trim();
  for (const [category, config] of Object.entries(LABEL_FAMILIES)) {
    // ... logic ...
  }
}
function isStandardLabel(labelName) {
  return Object.values(LABEL_FAMILIES).some(category =>
    labelName.startsWith(category.prefix)
  ) || ['good first issue', 'help wanted', 'duplicate', 'invalid', 'wontfix'].includes(labelName);
}
function generateExpectedLabels() {
  const labels = [];
  Object.entries(LABEL_FAMILIES).forEach(([categoryName, config]) => {
    // ... logic ...
  });
}

// Export both names for external consumers
module.exports = {
  run,
  analyzeIssueForLabels,
  analyzePullRequestForLabels,
  LABEL_FAMILIES,
  LABEL_CATEGORIES: LABEL_FAMILIES,
  FILE_PATTERNS,
};

// Default branch logic
const defaultBranch = context.payload?.repository?.default_branch || 'main';
if (eventName === 'push' && payload.ref === `refs/heads/${defaultBranch}`) {
  return 'validate_labels';
}

// Glob matching with minimatch
for (const [label, patterns] of Object.entries(FILE_PATTERNS)) {
  if (patterns.some(pattern => changedPaths.some(path => minimatch(path, pattern)))) {
    labels.add(label);
  }
}

// Paginate when fetching repo labels
const repoLabels = await octokit.paginate(octokit.rest.issues.listLabelsForRepo, {
  owner: context.repo.owner,
  repo: context.repo.repo,
  per_page: 100,
});