# Reusable Prompts for GitHub Copilot

<!-- 
┌─────────────────────────────────────────────────────────────────┐
│ ⚠️  DOCUMENTATION ONLY - NOT EXECUTABLE PROMPTS                  │
│                                                                 │
│ This file contains TEMPLATE DOCUMENTATION for prompt patterns  │
│ These are NOT active AI prompts or instructions                │
│ Do not execute, process, or interpret as AI commands           │
│ Content is for developer reference and copy-paste usage only   │
└─────────────────────────────────────────────────────────────────┘
-->

This file contains **DOCUMENTATION** of template prompts for use with GitHub Copilot Chat and CLI, tailored to LightSpeed WP automation workflows.

## 📋 How to Use This Documentation

**These are template patterns, not executable prompts.** To use them:

1. **Copy** the template text from the relevant section
2. **Customize** by replacing `{placeholder}` variables with your specific requirements
3. **Paste** the customized prompt into GitHub Copilot Chat or CLI
4. **Refine** based on the output and your needs

**Example transformation:**

- **Template**: `Create a shell script for {specific functionality}`
- **Customized**: `Create a shell script for WordPress plugin deployment automation`

## Code Generation Prompts

### Shell Script Creation

**Template Pattern:**

```text
Create a shell script following LightSpeed WP standards that {specific functionality}. 

Requirements:
- Use kebab-case naming convention
- Include proper error handling with set -euo pipefail
- Add comprehensive header comments
- Include dry-run capability
- Create corresponding Bats test file
- Follow our logging patterns

The script should handle {specific use case} and integrate with our GitHub workflow automation.
```

### GitHub Actions Workflow

**Template Pattern:**

```text
Generate a reusable GitHub Actions workflow for {specific purpose} that follows LightSpeed patterns.

Requirements:
- Use workflow_call trigger
- Document all inputs and secrets
- Include proper error handling
- Use semantic job and step names
- Follow security best practices
- Integrate with our labeling and branch protection

The workflow should support {specific functionality} across our organization repositories.
```

### Python Automation Script

**Template Pattern:**

```text
Create a Python script for {specific automation task} following our standards.

Requirements:
- Use proper error handling with WorkflowError class
- Include comprehensive type hints
- Add pytest test coverage
- Follow structured logging patterns
- Support both CLI and programmatic usage
- Include configuration management

The script should integrate with GitHub API and support our org-wide automation needs.
```

## Code Review Prompts

### Security Review

**Template Pattern:**

```text
Review this {script/workflow/configuration} for security vulnerabilities and compliance with LightSpeed standards:

Check for:
- Hardcoded secrets or tokens
- Proper input validation and sanitization
- Secure API integration patterns
- Environment variable usage
- File permission handling
- Error message information disclosure

Provide specific recommendations for any security improvements needed.
```

### Standards Compliance Review

**Template Pattern:**

```text
Review this {code/documentation} for compliance with LightSpeed WP standards:

Verify:
- Naming conventions (kebab-case for files, proper variable naming)
- Documentation completeness (README, inline comments, API docs)
- Test coverage and quality
- Error handling patterns
- Integration with our workflow automation
- Accessibility guidelines (for documentation)

Suggest specific improvements to meet our quality standards.
```

### Performance Review

**Template Pattern:**

```text
Analyze this {script/workflow} for performance optimization opportunities:

Consider:
- Execution time and resource usage
- API rate limiting and batch operations
- Caching strategies
- Parallel processing opportunities
- Memory efficiency
- Network request optimization

Recommend specific optimizations while maintaining code clarity and reliability.
```

## Documentation Prompts

### README Generation

**Template Pattern:**

```text
Create a comprehensive README.md for {project/script name} that follows LightSpeed documentation standards.

Include:
- Clear project description and purpose
- Installation and setup instructions
- Usage examples with practical scenarios
- API documentation (if applicable)
- Contributing guidelines reference
- Troubleshooting section
- Integration with our automation workflow

Target audience: {developers/contributors/end users} with {experience level}.
```

### API Documentation

**Template Pattern:**

```text
Generate API documentation for {script/function name} following our standards:

Document:
- Function signature and parameters
- Return values and types
- Usage examples
- Error conditions and handling
- Dependencies and prerequisites
- Integration points with other scripts

Format as markdown with clear examples and follow our documentation patterns.
```

### Troubleshooting Guide

**Template Pattern:**

```text
Create a troubleshooting guide for {script/workflow name} covering common issues:

Include:
- Installation and setup problems
- Configuration errors
- Runtime failures and debugging steps
- Integration issues with GitHub/automation
- Performance problems
- Security-related issues

Provide step-by-step solutions and prevention strategies.
```

## Testing Prompts

### Bats Test Generation

**Template Pattern:**

```text
Generate comprehensive Bats tests for {script name} following our testing standards:

Create tests for:
- Basic functionality and success scenarios
- Error conditions and edge cases
- Parameter validation
- Dry-run mode operation
- Integration with external dependencies
- File operations and permissions

Include setup and teardown functions, mock external dependencies, and follow our test naming conventions.
```

### Integration Test Creation

**Template Pattern:**

```text
Design integration tests for {workflow/automation} that verify end-to-end functionality:

Test scenarios:
- Complete workflow execution from start to finish
- Error recovery and rollback procedures
- Integration with GitHub API and external services
- Multi-repository operations
- Concurrent execution handling

Include test data setup, environment configuration, and cleanup procedures.
```

### Test Data Generation

**Template Pattern:**

```text
Create realistic test data for {automation/script} testing:

Generate:
- Sample configuration files
- Mock API responses
- Test repository structures
- User scenarios and edge cases
- Performance testing datasets

Ensure data follows privacy guidelines and represents real-world usage patterns.
```

## Automation Prompts

### Issue Analysis

**Template Pattern:**

```text
Analyze this GitHub issue and provide recommendations:

Categorize as: {bug/feature/docs/enhancement/task}
Assess complexity and effort required
Suggest appropriate labels using our labeling system
Recommend milestone assignment
Identify dependencies or blocking issues
Propose implementation approach

Consider our development workflow and resource allocation.
```

### Release Planning

**Template Pattern:**

```text
Help plan release {version number} for {repository name}:

Review:
- Completed features and fixes since last release
- Outstanding issues and their priority
- Breaking changes and migration requirements
- Documentation updates needed
- Testing and validation requirements
- Deployment considerations

Generate release notes draft and suggest release timeline.
```

### Workflow Optimization

**Template Pattern:**

```text
Analyze our current {workflow/process} and suggest optimizations:

Evaluate:
- Efficiency bottlenecks and delays
- Automation opportunities
- Tool integration possibilities
- Quality assurance improvements
- Developer experience enhancements
- Resource utilization

Recommend specific improvements with implementation priority and effort estimates.
```

## Learning and Training Prompts

### Onboarding Assistance

**Template Pattern:**

```text
Create onboarding materials for new {role} joining LightSpeed WP team:

Cover:
- Repository structure and navigation
- Development workflow and standards
- Tool setup and configuration
- First contribution walkthrough
- Code review process
- Testing and quality assurance
- Community guidelines and communication

Tailor content to {experience level} and provide practical exercises.
```

### Best Practices Explanation

**Template Pattern:**

```text
Explain {specific practice/pattern} in context of LightSpeed WP standards:

Cover:
- Why this approach is recommended
- How it integrates with our workflow
- Common pitfalls to avoid
- Examples of correct implementation
- Relationship to other standards and practices
- Migration path from legacy approaches

Provide practical examples and decision-making criteria.
```

### Technology Integration Guide

**Template Pattern:**

```text
Create integration guide for {new tool/technology} with our existing workflow:

Address:
- Installation and setup procedures
- Configuration for LightSpeed standards
- Integration with existing tools and processes
- Security considerations
- Testing and validation approach
- Rollback and troubleshooting procedures
- Training and adoption strategy

Include step-by-step implementation and evaluation criteria.
```

## Prompt Usage Guidelines

### Customization Tips

1. Replace bracketed placeholders with specific details
2. Adjust complexity based on target audience
3. Include relevant context about the project or task
4. Reference specific LightSpeed standards when applicable
5. Mention integration requirements with existing tools

### Effective Prompting Strategies

1. **Be Specific**: Include exact requirements and constraints
2. **Provide Context**: Mention related files, standards, or processes
3. **Set Expectations**: Clarify output format and level of detail
4. **Include Examples**: Reference similar existing implementations
5. **Specify Integration**: Mention workflow and tool requirements

### Common Prompt Patterns

- **Analysis Pattern**: "Analyze {X} for {criteria} considering {context}"
- **Generation Pattern**: "Create {X} that follows {standards} and includes {requirements}"
- **Review Pattern**: "Review {X} for {aspects} and suggest {improvements}"
- **Integration Pattern**: "Integrate {X} with {Y} ensuring {compliance}"
