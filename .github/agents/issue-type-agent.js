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

async function run() {
  try {
    // Get inputs from workflow
    const token = core.getInput('token', { required: true });
    const projectNumber = core.getInput('project-number', { required: true });
    const organization = core.getInput('organization', { required: true });
    
    // Get issue details from context
    const context = github.context;
    const issue = context.payload.issue;
    
    if (!issue) {
      core.info('No issue found in context. Skipping.');
      return;
    }
    
    core.info(`Processing issue #${issue.number}: ${issue.title}`);
    
    // Set up GraphQL client with authentication
    const graphqlWithAuth = graphql.defaults({
      headers: {
        authorization: `token ${token}`,
      },
    });
    
    // Determine issue type based on content analysis
    const issueType = await determineIssueType(issue);
    core.info(`Determined issue type: ${issueType}`);
    
    // Get Project and field data
    const projectData = await getProjectData(graphqlWithAuth, organization, parseInt(projectNumber));
    if (!projectData) {
      core.setFailed('Could not find project or type field.');
      return;
    }
    
    // Find the issue in the project
    const itemId = await findIssueInProject(graphqlWithAuth, projectData.id, issue.node_id);
    if (!itemId) {
      core.info('Issue not found in project. It may need to be added first.');
      return;
    }
    
    // Get type field options
    const typeField = projectData.fields.find(field => field.name.toLowerCase() === 'type');
    if (!typeField || !typeField.options) {
      core.setFailed('Type field not found or has no options.');
      return;
    }
    
    // Find the matching option ID
    const typeOption = typeField.options.find(option => 
      option.name.toLowerCase() === issueType.toLowerCase()
    );
    
    if (!typeOption) {
      core.info(`Could not find type option for "${issueType}". Available options: ${
        typeField.options.map(o => o.name).join(', ')
      }`);
      return;
    }
    
    // Update the issue's type in the project
    await updateIssueType(graphqlWithAuth, itemId, typeField.id, typeOption.id);
    core.info(`Successfully updated issue type to "${issueType}"`);
    
  } catch (error) {
    core.setFailed(`Action failed: ${error.message}`);
    if (error.message.includes('GraphQL')) {
      core.info('GraphQL Error Details:');
      core.info(JSON.stringify(error.errors || error, null, 2));
    }
  }
}

/**
 * Determines the issue type based on content analysis
 */
async function determineIssueType(issue) {
  const title = issue.title.toLowerCase();
  const body = (issue.body || '').toLowerCase();
  const content = `${title} ${body}`;
  
  // Define type detection patterns
  const patterns = {
    bug: ['bug', 'fix', 'error', 'crash', 'problem', 'not working', 'broken'],
    feature: ['feature', 'enhancement', 'add', 'new', 'implement', 'request'],
    task: ['task', 'chore', 'update', 'upgrade', 'maintenance', 'cleanup', 'refactor'],
    docs: ['docs', 'documentation', 'readme', 'guide', 'tutorial']
  };
  
  // Check for explicit type labels already on the issue
  if (issue.labels && issue.labels.length > 0) {
    for (const label of issue.labels) {
      const labelName = label.name.toLowerCase();
      if (labelName.includes('bug')) return 'Bug';
      if (labelName.includes('feature')) return 'Feature';
      if (labelName.includes('documentation')) return 'Documentation';
      if (labelName.includes('task')) return 'Task';
    }
  }
  
  // Look for type indicators in content
  for (const [type, keywords] of Object.entries(patterns)) {
    if (keywords.some(keyword => content.includes(keyword))) {
      // Map to standard type names
      switch (type) {
        case 'bug': return 'Bug';
        case 'feature': return 'Feature';
        case 'docs': return 'Documentation';
        case 'task': return 'Task';
        default: return 'Task';  // Default fallback
      }
    }
  }
  
  // Default to Task if no clear pattern is found
  return 'Task';
}

/**
 * Get project data including fields
 */
async function getProjectData(graphqlClient, org, number) {
  const query = `
    query($org: String!, $number: Int!) {
      organization(login: $org) {
        projectV2(number: $number) {
          id
          title
          fields(first: 20) {
            nodes {
              ... on ProjectV2SingleSelectField {
                id
                name
                options {
                  id
                  name
                }
              }
            }
          }
        }
      }
    }
  `;
  
  try {
    const result = await graphqlClient({
      query,
      org,
      number
    });
    
    const project = result.organization.projectV2;
    const fields = project.fields.nodes.map(node => {
      if (node.options) {
        return {
          id: node.id,
          name: node.name,
          options: node.options
        };
      }
      return {
        id: node.id,
        name: node.name
      };
    });
    
    return {
      id: project.id,
      title: project.title,
      fields
    };
  } catch (error) {
    core.error(`Error getting project data: ${error.message}`);
    return null;
  }
}

/**
 * Find an issue in a project
 */
async function findIssueInProject(graphqlClient, projectId, issueNodeId) {
  const query = `
    query($projectId: ID!, $issueNodeId: ID!) {
      node(id: $projectId) {
        ... on ProjectV2 {
          items(first: 1, filter: {contentIds: [$issueNodeId]}) {
            nodes {
              id
            }
          }
        }
      }
    }
  `;
  
  try {
    const result = await graphqlClient({
      query,
      projectId,
      issueNodeId
    });
    
    const items = result.node.items.nodes;
    if (items.length > 0) {
      return items[0].id;
    }
    return null;
  } catch (error) {
    core.error(`Error finding issue in project: ${error.message}`);
    return null;
  }
}

/**
 * Update the issue type in the project
 */
async function updateIssueType(graphqlClient, itemId, fieldId, optionId) {
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
    await graphqlClient({
      mutation,
      itemId,
      fieldId,
      optionId
    });
    return true;
  } catch (error) {
    core.error(`Error updating issue type: ${error.message}`);
    throw error;
  }
}

// Execute the script
run();