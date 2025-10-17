#!/usr/bin/env node
const core = require('@actions/core');
const github = require('@actions/github');
const { graphql } = require('@octokit/graphql');
const fs = require('fs');
const path = require('path');

function input(name, opts={}){
  // Support core.getInput, INPUT_* and plain env vars for CLI usage
  const v = core.getInput(name, opts) ||
            process.env[`INPUT_${name.replace(/[- ]/g,'_').toUpperCase()}`] ||
            process.env[name.replace(/[- ]/g,'_').toUpperCase()] ||
            process.env[name];
  if (opts.required && !v) throw new Error(`Missing input: ${name}`);
  return v;
}

function token(){ return input('github-token') || process.env.GITHUB_TOKEN; }
function readJson(p, fallback){ try { return JSON.parse(fs.readFileSync(p,'utf8')); } catch(e){ return fallback; } }

const BUILTIN = [
  {name:'Epic', label:'type:epic'},{name:'Feature', label:'type:feature'},{name:'Story', label:'type:story'},
  {name:'Task', label:'type:task'},{name:'Bug', label:'type:bug'},{name:'Refactor', label:'type:refactor'},
  {name:'Design', label:'type:design'},{name:'Documentation', label:'type:documentation'},
  {name:'Research', label:'type:research'},{name:'Performance', label:'type:performance'},
  {name:'Accessibility', label:'type:a11y'},{name:'Test', label:'type:test'},{name:'Chore', label:'type:chore'},
];

function branchToType(branch){
  if(/^feat\//i.test(branch)) return 'Feature';
  if(/^fix\//i.test(branch)) return 'Bug';
  if(/^refactor\//i.test(branch)) return 'Refactor';
  if(/^docs\//i.test(branch)) return 'Documentation';
  if(/^chore\//i.test(branch) || /^build\//i.test(branch)) return 'Chore';
  return null;
}

async function run(){
  try{
    const tk = token(); if(!tk) throw new Error('Missing token');
    const org = input('organization', {required:true});
    const projectNumber = parseInt(input('project-number', {required:true}),10);
    const ctx = github.context;
    const item = ctx.payload.issue || ctx.payload.pull_request;
    if(!item){ core.info('No issue/PR in context.'); return; }

    const cfg = readJson(path.join(process.cwd(), 'config', 'issue-types.json'), []);
    const candidates = cfg.length ? cfg : BUILTIN;

    const labels = (item.labels || []).map(l => (l.name||'').toLowerCase());
    let picked = null;
    for(const t of candidates){
      if(t.label && labels.includes(t.label.toLowerCase())) { picked = t.name; break; }
    }
    if(!picked && item.head && item.head.ref){
      picked = branchToType(item.head.ref);
    }
    if(!picked){
      const content = ((item.title||'')+' '+(item.body||'')).toLowerCase();
      const kw = [['Bug',['bug','fix','error','crash','regression']],['Feature',['feature','enhancement','new']],
        ['Documentation',['docs','readme','guide','changelog']],['Refactor',['refactor','restructure','rewrite']],
        ['Design',['design','figma','prototype']],['Performance',['performance','lcp','cls','speed','optimize']],
        ['Accessibility',['a11y','accessibility','wcag']],['Test',['test','unit','integration','coverage']],
        ['Chore',['chore','cleanup','maintenance']]];
      for(const [type, keys] of kw){ if(keys.some(k => content.includes(k))) { picked = type; break; } }
    }
    if(!picked) picked = 'Task';

    const gql = graphql.defaults({ headers: { authorization: `token ${tk}` } });
    const proj = await gql(`query($org:String!,$num:Int!){
      organization(login:$org){
        projectV2(number:$num){
          id title fields(first:50){ nodes {
            ... on ProjectV2SingleSelectField { id name options{ id name } }
            ... on ProjectV2FieldCommon { id name }
          } }
        }
      }
    }`, { org, num: projectNumber });

    const project = proj?.organization?.projectV2;
    if(!project){ core.setFailed('Project not found'); return; }
    const fields = (project.fields?.nodes || []).map(n=>({id:n.id,name:n.name,options:n.options||null}));
    const typeField = fields.find(f => f.name && f.name.toLowerCase()==='type' && Array.isArray(f.options));
    if(!typeField){ core.setFailed('Type field missing'); return; }

    const contentId = item.node_id;
    const itemRes = await gql(`query($pid:ID!,$cid:ID!){
      node(id:$pid){ ... on ProjectV2 { items(first:1, filter:{contentIds:[$cid]}){ nodes{ id } } } }
    }`, { pid: project.id, cid: contentId });
    const projItemId = itemRes?.node?.items?.nodes?.[0]?.id || null;
    if(!projItemId){ core.info('Item not in project; skipping.'); return; }

    const opt = (typeField.options||[]).find(o => (o.name||'').toLowerCase() === picked.toLowerCase());
    if(!opt){ core.info(`No matching Type option for "${picked}"`); return; }
    await gql(`mutation($pid:ID!,$iid:ID!,$fid:ID!,$oid:String!){
      updateProjectV2ItemFieldValue(input:{
        projectId:$pid,itemId:$iid,fieldId:$fid,value:{singleSelectOptionId:$oid}
      }){ projectV2Item{ id } }
    }`, { pid: project.id, iid: projItemId, fid: typeField.id, oid: opt.id });

    core.info(`Set Type → ${opt.name}`);
  }catch(e){ core.setFailed(e.message); }
}

if(require.main===module) run();
module.exports = { run };

