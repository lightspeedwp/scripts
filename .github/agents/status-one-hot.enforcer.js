#!/usr/bin/env node
const core = require('@actions/core');
const github = require('@actions/github');

const STATUS_PREFIX = 'status:';
const PRIORITY_PREFIX = 'priority:';
const DEFAULT_STATUS_ISSUE = 'status:needs-triage';
const DEFAULT_STATUS_PR = 'status:needs-review';
const DEFAULT_PRIORITY = 'priority:normal';

async function run() {
  try {
    const token = process.env.GITHUB_TOKEN || core.getInput('github-token');
    if (!token) throw new Error('Missing GITHUB_TOKEN');
    const octo = github.getOctokit(token);
    const ctx = github.context;
    const isIssue = !!ctx.payload.issue;
    const isPR = !!ctx.payload.pull_request;
    if (!isIssue && !isPR) {
      core.info('No issue or PR context; exiting.');
      return;
    }
    const number = isIssue ? ctx.payload.issue.number : ctx.payload.pull_request.number;
    const owner = ctx.repo.owner, repo = ctx.repo.repo;

    const { data: current } = await octo.rest.issues.get({ owner, repo, issue_number: number });
    const names = (current.labels || []).map(l => l.name).filter(Boolean);

    // Enforce exactly one status:*
    const statuses = names.filter(n => n.startsWith(STATUS_PREFIX));
    if (statuses.length === 0) {
      const desired = isPR ? DEFAULT_STATUS_PR : DEFAULT_STATUS_ISSUE;
      await octo.rest.issues.addLabels({ owner, repo, issue_number: number, labels: [desired] });
      core.info(`Applied default status: ${desired}`);
    } else if (statuses.length > 1) {
      const keep = statuses[0];
      for (const name of statuses.slice(1)) {
        await octo.rest.issues.removeLabel({ owner, repo, issue_number: number, name });
        core.info(`Removed extra status label: ${name}`);
      }
      core.info(`Kept status label: ${keep}`);
    }

    // Default priority on issues
    if (isIssue) {
      const hasPriority = names.some(n => n.startsWith(PRIORITY_PREFIX));
      if (!hasPriority) {
        await octo.rest.issues.addLabels({ owner, repo, issue_number: number, labels: [DEFAULT_PRIORITY] });
        core.info(`Applied default priority: ${DEFAULT_PRIORITY}`);
      }
    }
  } catch (e) {
    core.setFailed(e.message);
  }
}

if (require.main === module) run();
module.exports = { run };

