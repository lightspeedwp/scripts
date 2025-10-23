/**
 * ============================================================================

const actionsCore = require('@actions/core');
const actionsGithub = require('@actions/github');
 * Description:
 *   - Analyzes issues and PRs and assigns appropriate issue type labels.
 *   - Main functions: run(), canonical type lookup, alias heuristics, type label application, report generation.
 *   - Uses shared utilities: type-lookup, label-reporting.
 *   - Shared test helpers: mockOctokit, mockContext, expectMarkdownReport, mockIssuePayload, expectDryRun, etc.
 *   - Coverage: Type assignment, heuristics, markdown report, dry-run, error handling.
 * Standards:
 *   - Follows [LightSpeed Coding Standards](https://github.com/lightspeedwp/.github/blob/master/.github/instructions/coding-standards.instructions.md)
 *   - See org instructions: [Custom Instructions](https://github.com/lightspeedwp/.github/blob/master/.github/custom-instructions.md)
 * Contribution:
 *   - Update docblock with new functions or helpers
 *   - Add new helpers to tests/utility/test-helpers.js as needed
 * ============================================================================
 */

const {
    fetchCanonicalIssueTypes,
    buildTypeAliasMap,
    findStandardType,
} = require('../../scripts/utility/type-lookup');
// buildLabelingReport is not used, so removed to fix no-unused-vars
const actionsCore = require('@actions/core');
const actionsGithub = require('@actions/github');

const config = {
    dryRun: process.env.DRY_RUN === 'true',
    token: process.env.GITHUB_TOKEN,
    orgOwner: 'lightspeedwp',
    orgRepo: '.github',
};

/**
 * Main orchestrator for issue type agent.
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

        const canonicalTypes = await fetchCanonicalIssueTypes(
            octokit,
            config.orgOwner,
            config.orgRepo
        );
        const aliasMap = buildTypeAliasMap(canonicalTypes);

        const item = context.payload.issue || context.payload.pull_request;
        if (!item) {
            actionsCore.info('No issue or PR in context; exiting.');
            return;
        }
        const issueOrPrNumber = item.number;
        const labels = (item.labels || []).map((l) => l.name || l);

        let typeLabel = labels.find((l) => findStandardType(l, aliasMap));
        if (!typeLabel) {
            const content =
                `${item.title || ''} ${item.body || ''}`.toLowerCase();
            for (const t of Object.keys(aliasMap)) {
                if (content.includes(t)) {
                    typeLabel = aliasMap[t];
                    break;
                }
            }
        }
        if (!typeLabel) {
            typeLabel = 'type:task';
        }

        if (!labels.includes(typeLabel) && !config.dryRun) {
            await octokit.rest.issues.addLabels({
                owner,
                repo,
                issue_number: issueOrPrNumber,
                labels: [typeLabel],
            });
            actionsCore.info(
                `Applied type label to #${issueOrPrNumber}: ${typeLabel}`
            );
        } else if (config.dryRun) {
            actionsCore.info(
                `[DRY RUN] Would apply type label to #${issueOrPrNumber}: ${typeLabel}`
            );
        }

        const report = {
            type: context.payload.issue ? 'Issue' : 'Pull Request',
            newLabels: [typeLabel],
            suggestions: [],
        };
        if (!config.dryRun) {
            await octokit.rest.issues.createComment({
                owner,
                repo,
                issue_number: issueOrPrNumber,
                body: JSON.stringify(report, null, 2),
            });
            actionsCore.info(
                `Posted type labeling report for #${issueOrPrNumber}`
            );
        } else {
            actionsCore.info(JSON.stringify(report, null, 2));
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
