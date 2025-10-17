#!/usr/bin/env node
/**
* Script Name: label-standardization.agent.js
* Description: Label Standardization Agent. Enforces org-wide label standards, detects and migrates non-standard labels, and deletes redundant labels. Integrates with automation workflows for repository management.
* Version: v1.0.0
* Author: LightSpeed WP Team
* Github Contributors: See repo history
* Author URI: https://lightspeedwp.agency/
* License: GPL v3 or later
* License URI: https://www.gnu.org/licenses/gpl-3.0.html
* Requirements: Node.js, @octokit/rest, @actions/core, @actions/github
* Usage: Used in workflows: label-standardization.yml, label-enforcement.yml, pr-labels-project-sync.yml, issue-labels-project-sync.yml
* Environment Variables:
*   - GITHUB_TOKEN: Required for API access
*   - DRY_RUN: Set to "true" to preview without making changes
*   - VERBOSE: Set to "true" for detailed logs
* Options: None (all configuration via env vars and workflow inputs)
* Examples:
*   - node .github/agents/label-standardization.agent.js
*   - Used via GitHub Actions workflow
* Notes:
*   - Aligns with org-wide-labels-v1-12.md, label-automation-strategy-v1-1.md
*   - See related script: manage-labels.sh, prune-labels.sh
*   - See related tests: test-manage-labels.bats, label-standardization.agent.test.js
 */


const { Octokit } = require('@octokit/rest');
const core = require('@actions/core');
const github = require('@actions/github');

// Label mappings from non-standard to standard
const LABEL_MAPPINGS = [
  // Language labels
  { nonStandard: 'php', standard: 'lang:php' },
  { nonStandard: 'javascript', standard: 'lang:js' },
  { nonStandard: 'js', standard: 'lang:js' },
  { nonStandard: 'css', standard: 'lang:css' },
  { nonStandard: 'html', standard: 'lang:html' },
  { nonStandard: 'python', standard: 'lang:python' },
  { nonStandard: 'typescript', standard: 'lang:typescript' },
  { nonStandard: 'ts', standard: 'lang:typescript' },
  { nonStandard: 'bash', standard: 'lang:bash' },
  { nonStandard: 'shell', standard: 'lang:bash' },

  // Area labels
  { nonStandard: 'documentation', standard: 'area:documentation' },
  { nonStandard: 'docs', standard: 'area:documentation' },
  { nonStandard: 'testing', standard: 'area:testing' },
  { nonStandard: 'tests', standard: 'area:testing' },
  { nonStandard: 'ci', standard: 'area:ci' },
  { nonStandard: 'workflow', standard: 'area:ci' },
  { nonStandard: 'security', standard: 'area:security' },
  { nonStandard: 'performance', standard: 'area:performance' },
  { nonStandard: 'ui', standard: 'area:ui' },
  { nonStandard: 'ux', standard: 'area:ux' },
];

// Config
const config = {
  dryRun: process.env.DRY_RUN === 'true',
  verbose: process.env.VERBOSE === 'true',
  token: process.env.GITHUB_TOKEN,
};

/**
 * Main function
 */
async function run() {
  try {
    // Initialize octokit
    if (!config.token) {
      throw new Error('GITHUB_TOKEN is required');
    }

    const octokit = new Octokit({ auth: config.token });
    const context = github.context;
    const repo = context.repo.repo;
    const owner = context.repo.owner;

    // Get repository labels
    const labels = await getRepositoryLabels(octokit, owner, repo);
    log(`Found ${labels.length} labels in repository ${owner}/${repo}`);

    // Find non-standard labels that have standard equivalents
    const labelsToStandardize = findLabelsToStandardize(labels);
    log(`Found ${labelsToStandardize.length} non-standard labels to standardize`);

    // Process each non-standard label
    for (const labelPair of labelsToStandardize) {
      await standardizeLabel(octokit, owner, repo, labelPair);
    }

    log('Label standardization completed successfully');

  } catch (error) {
    core.setFailed(`Error: ${error.message}`);
  }
}

/**
 * Get all labels in the repository
 */
async function getRepositoryLabels(octokit, owner, repo) {
  const labelsResponse = await octokit.paginate(
    octokit.issues.listLabelsForRepo,
    {
              repo,
      per_page: 100,
    }
  );

  return labelsResponse;
}

/**
 * Find non-standard labels that have standard equivalents
 */
function findLabelsToStandardize(labels) {
  const labelsToStandardize = [];
  const labelNames = labels.map(label => label.name);

  for (const mapping of LABEL_MAPPINGS) {

    if (
      labelNames.includes(mapping.nonStandard) &&
      labelNames.includes(mapping.standard)
    ) {
      labelsToStandardize.push(mapping);
    }
  }

  return labelsToStandardize;
}

/**
 * Standardize a label by migrating issues/PRs and removing the non-standard label
 */
async function standardizeLabel(octokit, owner, repo, labelPair) {
  const { nonStandard, standard } = labelPair;

  log(`Standardizing label: ${nonStandard} → ${standard}`);

  // Find issues/PRs with the non-standard label
  const issues = await octokit.paginate(
    octokit.issues.listForRepo,
    {
      owner,
      repo,
      labels: nonStandard,
      state: 'all',
      per_page: 100,
    }
  );

  log(`Found ${issues.length} issues/PRs with label "${nonStandard}"`);

  // Update each issue/PR
  for (const issue of issues) {
    await updateIssueLabels(octokit, owner, repo, issue, nonStandard, standard);
  }

  // Delete the non-standard label if not in dry run mode
  if (!config.dryRun) {
    try {
      await octokit.issues.deleteLabel({
        owner,
        repo,
        name: nonStandard,
      });
      log(`Deleted non-standard label: ${nonStandard}`);
    } catch (error) {
      log(`Error deleting label ${nonStandard}: ${error.message}`, 'error');
    }
  } else {
    log(`[DRY RUN] Would delete non-standard label: ${nonStandard}`);
  }
}

/**
 * Update labels on an issue or PR
 */
async function updateIssueLabels(octokit, owner, repo, issue, nonStandard, standard) {
  const issueNumber = issue.number;

  // Get current labels and ensure we don't duplicate the standard label
  const currentLabels = issue.labels.map(label => label.name);
  const updatedLabels = currentLabels.filter(label => label !== nonStandard);

  if (!updatedLabels.includes(standard)) {
    updatedLabels.push(standard);
  }

  // Update the issue's labels
  if (!config.dryRun) {
    try {
      await octokit.issues.setLabels({
        owner,
        repo,
        issue_number: issueNumber,
        labels: updatedLabels,
      });
      log(`Updated #${issueNumber}: Replaced "${nonStandard}" with "${standard}"`);
    } catch (error) {
      log(`Error updating #${issueNumber}: ${error.message}`, 'error');
    }
  } else {
    log(`[DRY RUN] Would update #${issueNumber}: Replace "${nonStandard}" with "${standard}"`);
  }
}

/**
 * Logging helper
 */
function log(message, level = 'info') {
  if (level === 'info') {
    if (config.verbose || !message.startsWith('[DRY RUN]')) {
      console.log(message);
      if (core.info) core.info(message);
    }
  } else if (level === 'error') {
    console.error(message);
    if (core.error) core.error(message);
  } else if (level === 'warning') {
    console.warn(message);
    if (core.warning) core.warning(message);
  }
}

// Execute if run directly
if (require.main === module) {
  run();
}

module.exports = {
  run,
  findLabelsToStandardize,
  LABEL_MAPPINGS,
};
