/**
 * ============================================================================
 * Agent: label-standardization.agent.js
 * Location: .github/agents/label-standardization.agent.js
 * Description:
 *   - Migrates non-standard labels to canonical forms and removes redundant labels.
 *   - Main functions: run(), canonical lookup, label alias mapping, standardization, sync, markdown report.
 *   - Uses shared utilities: label-lookup, label-sync, label-reporting.
 *   - Shared test helpers: mockOctokit, mockContext, expectMarkdownReport, mockPrPayload, expectDryRun, etc.
 *   - Coverage: Validates repo labels, migrates non-standard, syncs canonical, posts reports, handles dry-run and errors.
 * Standards:
 *   - Follows [LightSpeed Coding Standards](https://github.com/lightspeedwp/.github/blob/master/.github/instructions/coding-standards.instructions.md)
 *   - See org instructions: [Custom Instructions](https://github.com/lightspeedwp/.github/blob/master/.github/custom-instructions.md)
 * Contribution:
 *   - Update docblock with changes in agent logic or helper usage
 *   - Add new helpers to tests/utility/test-helpers.js as needed
 * ============================================================================
 */

const {
    fetchCanonicalLabels,
    buildLabelAliasMap,
} = require('../../scripts/utility/label-lookup');
const {
    standardizeLabelsOnRepo,
    validateRepoLabels,
    syncLabelsWithCanonical,
} = require('../../scripts/utility/label-sync');
const {
    buildStandardizationReport,
} = require('../../scripts/utility/label-reporting');
const actionsCore = require('@actions/core');
const actionsGithub = require('@actions/github');

const config = {
    dryRun: process.env.DRY_RUN === 'true',
    token: process.env.GITHUB_TOKEN,
    orgOwner: 'lightspeedwp',
    orgRepo: '.github',
};

/**
 * Main orchestrator for label standardization agent.
 * @param {Object} context - GitHub Actions context object.
 * @returns {Promise<void>}
 */
async function run(context = actionsGithub.context) {
    try {
        if (!config.token) {
            throw new Error('GITHUB_TOKEN is required');
        }
        const octokit = actionsGithub.getOctokit(config.token);
        const owner = context.repo.owner;
        const repo = context.repo.repo;

        // Fetch canonical labels and build alias map
        const canonicalLabels = await fetchCanonicalLabels(
            octokit,
            config.orgOwner,
            config.orgRepo
        );
        const aliasMap = buildLabelAliasMap(canonicalLabels);

        // Validate repo labels against canonical
        const validationReport = await validateRepoLabels(
            octokit,
            owner,
            repo,
            canonicalLabels
        );

        // Standardize labels in repo (migrate non-standard labels to canonical)
        const migratedLabels = await standardizeLabelsOnRepo(
            octokit,
            owner,
            repo,
            aliasMap
        );

        // Sync repo labels with canonical set (create/update/delete as needed)
        await syncLabelsWithCanonical(octokit, owner, repo, canonicalLabels);

        // Build and post standardization report using shared utility
        const report = buildStandardizationReport({
            nonStandardLabels: validationReport.nonStandardLabels || [],
            migratedLabels: migratedLabels || [],
        });

        if (!config.dryRun) {
            if (
                context.payload &&
                (context.payload.issue || context.payload.pull_request)
            ) {
                const issueOrPrNumber = (
                    context.payload.issue || context.payload.pull_request
                ).number;
                await octokit.rest.issues.createComment({
                    owner,
                    repo,
                    issue_number: issueOrPrNumber,
                    body: report,
                });
                actionsCore.info(
                    `Posted label standardization report for #${issueOrPrNumber}`
                );
            } else {
                actionsCore.info(report);
            }
        } else {
            actionsCore.info(
                '[DRY RUN] Would post standardization report:\n' + report
            );
        }
    } catch (e) {
        actionsCore.setFailed(e.message);
    }
}

if (require.main === module) {
    run();
}

module.exports = {
    run,
};
