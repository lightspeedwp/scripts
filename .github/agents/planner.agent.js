#!/usr/bin/env node
const core = require('@actions/core');
const github = require('@actions/github');
async function run(){
  try{
    const dry = (core.getInput('dry-run')||process.env.DRY_RUN)==='true';
    const ctx = github.context; const pr = ctx.payload.pull_request;
    if(!pr){ core.info('No PR in context'); return; }
    const checklist = [
      '- [ ] Confirm scope & acceptance criteria',
      '- [ ] Link related issues & project items',
      '- [ ] Update/verify tests & coverage',
      '- [ ] Run linters/formatters',
      '- [ ] Update CHANGELOG.md (if user-facing)',
      '- [ ] Update docs (README/examples)',
      '- [ ] Security & secrets check',
      '- [ ] Self-review; request review'
    ];
    const body = `## 🧭 Planner: Task Ledger for PR #${pr.number}
**Title:** ${pr.title}

### Checklist
${checklist.join('\n')}

### Exit Criteria
- Tests green, linters clean
- Reviewer approvals complete
- No blocking labels
`;
    if(dry){ core.info(body); return; }
    const octo = github.getOctokit(process.env.GITHUB_TOKEN||core.getInput('github-token'));
    await octo.rest.issues.createComment({ owner:ctx.repo.owner, repo:ctx.repo.repo, issue_number:pr.number, body });
    core.info('Planner comment posted.');
  }catch(e){ core.setFailed(e.message); }
}
if(require.main===module) run();
module.exports = { run };
