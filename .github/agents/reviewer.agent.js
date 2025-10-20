#!/usr/bin/env node
const core = require('@actions/core');
const github = require('@actions/github');
async function run(){
  try{
    const token = core.getInput('github-token')||process.env.GITHUB_TOKEN;
    if(!token) throw new Error('Missing token');
    const requireChangelog = (core.getInput('require-changelog')||'false')==='true';
    const ctx = github.context; const pr = ctx.payload.pull_request;
    if(!pr){ core.info('No PR in context'); return; }
    const octo = github.getOctokit(token);
    let state='unknown';
    try{
      const {data}=await octo.rest.repos.getCombinedStatusForRef({owner:ctx.repo.owner,repo:ctx.repo.repo,ref:pr.head.sha});
      state=data.state;
    }catch{}
    const {data:files}=await octo.rest.pulls.listFiles({owner:ctx.repo.owner,repo:ctx.repo.repo,pull_number:pr.number,per_page:100});
    const changed=files.map(f=>f.filename);
    const srcTouched=changed.some(f=>f.startsWith('src/')||/\.(js|ts|php|py)$/i.test(f));
    const hasChangelog=changed.some(f=>f.toLowerCase()==='changelog.md');
    const blockers=[];
    if(state!=='success') blockers.push('CI checks not green');
    if(requireChangelog && srcTouched && !hasChangelog) blockers.push('CHANGELOG.md missing for code change');
    const emoji=blockers.length?'❌':(state==='success'?'✅':'⚠️');
    const body=`## 🔍 Reviewer Summary for PR #${pr.number}
**CI Status:** ${emoji} \`${state}\`
**Files changed:** ${files.length}

### Recommendations
${blockers.length?blockers.map(b=>`- ${b}`).join('\n'):'- Ready to proceed pending human review'}
`;
    await octo.rest.issues.createComment({owner:ctx.repo.owner,repo:ctx.repo.repo,issue_number:pr.number,body});
    core.info('Reviewer comment posted.');
  }catch(e){ core.setFailed(e.message); }
}
if(require.main===module) run();
module.exports = { run };
