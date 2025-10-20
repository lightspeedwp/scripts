#!/usr/bin/env node
/**
 * Issue Type Assignment Agent
 * 
 * This agent automatically assigns issue types to newly created GitHub issues 
 * based on content analysis and project configuration.
 * 
 * It serves as a bridge between GitHub Issues and GitHub Projects V2,
 * ensuring consistent issue categorization across repositories.
 */

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

// CRITICAL FIX: updateIssueType signature and call
async function updateIssueType(graphqlClient, projectId, itemId, fieldId, optionId) {
  const mutation = `
    mutation($projectId: ID!, $itemId: ID!, $fieldId: ID!, $optionId: String!) {
      updateProjectV2ItemFieldValue(
        input: {
          projectId: $projectId,
          itemId: $itemId,
          fieldId: $fieldId,
          value: {
            singleSelectOptionId: $optionId
          }
        }
      ) {
        projectV2Item {
          id
        }
      }
    }
  `;
  try {
    await graphqlClient({ mutation, projectId, itemId, fieldId, optionId });
    return true;
  } catch (error) {
    core.error(`Error updating issue type: ${error.message}`);
    throw error;
  }
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
      ];
      for(const [type, arr] of kw){
        if(arr.some(k => content.includes(k))) { picked = type; break; }
      }
    }
    // CRITICAL FIX: Make template “type:” parsing case-insensitive and resilient.
    if (item.body && /type:/i.test(item.body)) {
      const typeMatch = item.body.match(/type:\s*['"]([^'"]+)['"]/i);
      if (typeMatch) picked = typeMatch[1];
    }

    // ... Further logic for updating issue type and project fields ...
  } catch(err) {
    core.setFailed(err.message);
  }
}

if(require.main === module){ run(); }