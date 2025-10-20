#!/usr/bin/env node
/**
 * Label Standardization Agent
 * 
 * This agent enforces label standards across repositories by:
 * 1. Detecting non-standard labels (e.g., "php" vs "lang:php")
 * 2. Migrating issues/PRs to use standardized labels
 * 3. Deleting redundant non-standard labels after migration
 * 
 * Usage:
 * - Automatically runs via GitHub Actions
 * - Can be run manually with appropriate permissions
 * 
 * Environment Variables:
 * - GITHUB_TOKEN: Required for API access
 * - DRY_RUN: Set to "true" to preview without making changes
 * - VERBOSE: Set to "true" for detailed logs
 */

const core = require('@actions/core');
const github = require('@actions/github');
const { Octokit } = require('@octokit/rest');

// Helper for logging
function log(msg) {
  if (process.env.GITHUB_ACTIONS) {
    core.info(msg);
  } else {
    console.log(msg);
  }
}

// Fetch all labels for a repo (paginated)
async function getRepoLabels(octokit, owner, repo) {
  return await octokit.paginate(octokit.rest.issues.listLabelsForRepo, {
    owner,
    repo,
    per_page: 100,
  });
}

// Fetch all issues for a repo with a label (paginated)
async function getIssuesWithLabel(octokit, owner, repo, label) {
  return await octokit.paginate(octokit.rest.issues.listForRepo, {
    owner,
    repo,
    labels: label,
    state: 'all',
    per_page: 100,
  });
}

// Auto-create standard label if missing
async function ensureStandardLabelExists(octokit, owner, repo, standard, config) {
  try {
    await octokit.rest.issues.getLabel({ owner, repo, name: standard });
  } catch {
    if (!config.dryRun) {
      await octokit.rest.issues.createLabel({
        owner, repo, name: standard, color: '0e8a16', description: `Standardized: ${standard}`,
      });
      log(`Created standard label: ${standard}`);
    } else {
      log(`[DRY RUN] Would create standard label: ${standard}`);
    }
  }
}

async function standardizeLabel(octokit, owner, repo, labelPair, config) {
  const { nonStandard, standard } = labelPair;
  log(`Standardizing label: ${nonStandard} → ${standard}`);
  await ensureStandardLabelExists(octokit, owner, repo, standard, config);
  // ... Label migration logic here ...
}

// Example config object
const config = {
  dryRun: process.env.DRY_RUN === 'true',
};

// Example usage in main logic
async function run() {
  const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
  const owner = github.context.repo.owner;
  const repo = github.context.repo.repo;

  // Example: Find non-standard labels and standardize
  const repoLabels = await getRepoLabels(octokit, owner, repo);
  // ... Find mappings, call standardizeLabel() as needed ...
}

if (require.main === module) { run(); }

// Meta: spelling fix: “GitHub Contributors: See repo history” in headers