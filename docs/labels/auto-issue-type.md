# Auto Issue Type Workflow

This workflow automatically assigns appropriate issue types to newly created issues based on their content, labels, and template metadata. It bridges the gap between traditional GitHub issues and the project field-based issue type system used in this repository, following the organization-wide Issue Types standards (v1.9).

## How It Works

1. **Trigger**: When a new issue is created or reopened
2. **Analysis**: Examines issue template type, title, body content, and labels
3. **Type Assignment**: Determines appropriate issue type based on predefined rules
4. **Project Integration**: Adds issue to relevant projects if not already present
5. **Field Update**: Sets the "Issue Type" project field to the determined value

## Issue Type Alignment

This workflow aligns with the organization-wide issue types defined in `org-wide-issue-types-v1-9.md`:

| Issue Type | Color | Usage |
|------------|-------|-------|
| 🧩 Task | Blue #4393f8 | Small, well-defined work items |
| 🐞 Bug | Red #9f3734 | Defects requiring fixes |
| ✨ Feature | Green #3fb950 | New functionality |
| 🎨 Design | Purple #ab7df8 | UI/UX work |
| 🧭 Epic | Purple #ab7df8 | Large initiatives grouping multiple issues |
| 📖 Story | Blue #4393f8 | User-focused feature descriptions |
| 🔧 Improvement | Grey #9198a1 | Enhancements to existing functionality |
| ♻️ Refactor | Grey #9198a1 | Code improvement without behavioral changes |
| ⚙️ Build & CI | Blue #4393f8 | CI/CD and tooling improvements |
| 📚 Documentation | Blue #4393f8 | Documentation updates |

## Type Assignment Priority

1. Issue template `type:` field (highest priority)
2. Existing issue labels
3. Content pattern matching
4. Default fallback (Task)

## Required Permissions

- `contents: read`
- `issues: write`
- `repository-projects: write`

## Implementation Details

The workflow:

1. Uses GitHub's GraphQL API to access project and issue data
2. Determines issue type based on content analysis
3. Locates applicable organization projects with "Issue Type" fields
4. Adds the issue to projects and sets the Issue Type field value

## Integration with Existing Systems

This workflow complements the existing:

- Issue labeler workflow (which assigns labels)
- Project setup scripts (which define the Issue Type field)
- Manual project management processes

## Troubleshooting

If issues aren't getting their types assigned:

1. Ensure the workflow has necessary permissions
2. Verify at least one project has an "Issue Type" field
3. Check that the issue type names in the workflow match your project field options
4. Review the workflow run logs for specific errors

## Next Steps

After the issue type is assigned:

- The issue will appear in project boards with the correct type
- Issue can be further processed by other workflows and automations
- Project views that filter or group by Issue Type will include the new issue
