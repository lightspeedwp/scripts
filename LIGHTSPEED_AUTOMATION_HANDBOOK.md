# LightSpeed Automation & Governance Handbook

This documentation bundles all org-wide automation, workflow, branching, label governance, and project templates discussed in our Copilot Space, including shell scripts, workflows, and configuration files. It is intended for onboarding, reference, and automation engineers contributing to https://github.com/lightspeedwp/scripts/.

## Table of Contents

- [Branching Strategy (client & product)](#branching-strategy-client--product)
- [Changelog & Release Automation (client & product)](#changelog--release-automation-client--product)
- [Label Automation Strategy](#label-automation-strategy)
- [Issue Types & PR Labelling](#issue-types--pr-labelling)
- [Project Templates (client & product)](#project-templates-client--product)
- [GitHub Actions, Workflows, and Governance](#github-actions-workflows-and-governance)
- [Rollout Plan & Quality Gates](#rollout-plan--quality-gates)

---

## Branching Strategy (client & product)

Our org-wide Git branching strategy ensures `main` is always deployable, reduces merge risk, and makes PR automation predictable across all repositories. This policy aligns branch names with **Issue Types** and **Projects** so reports and saved searches work cross-repo.

### High-level Rules

- `main` is production-ready at all times
- Optional `develop` for teams that need an integration branch
- Short-lived branches only; open a PR early and keep it small
- Squash merge to preserve a **linear history**; delete branch after merge
- Use prefixes that map cleanly to Issue Types and Project fields

### Branch Naming Convention

**Format:** `{type}/{scope}-{short-title}`  
*lower-case; kebab-case; keep it short.*

#### Allowed Branch Prefixes

| Prefix | Intended work | Maps to Project Type | Typical Issue Type |
|--------|---------------|---------------------|-------------------|
| `feat/` | New capability | **Feature** | Feature |
| `fix/` | Defect/regression | **Bug** | Bug |
| `docs/` | Docs & comms | **Documentation** | Documentation |
| `chore/` | Housekeeping, deps | **Task** | Maintenance / Build & CI / Chore |
| `refactor/` | Internal restructure | **Refactor** | Code Refactor |
| `test/` | Tests only | **Test Coverage** | Test Coverage |
| `perf/` | Performance work | **Performance** | Performance |
| `ci/` | Workflow changes | **Build & CI** | Build & CI |
| `release/` | Release prep | **Release** | Release |
| `hotfix/` | Emergency prod fix | **Release** | Bug / Release |

#### Client Delivery Extensions

For client-specific work, additional prefixes are available:
- `content/` — content migration/editing
- `seo/` — SEO optimization tasks
- `config/` — configuration changes
- `migrate/` — data migration tasks
- `qa/` — QA/testing specific tasks
- `uat/` — User Acceptance Testing

#### Product Development Extensions

For product development, additional prefixes are available:
- `proto/` — prototyping/proof-of-concept
- `ds/` — design system updates
- `api/` — API development
- `schema/` — database schema changes
- `telemetry/` — analytics/telemetry implementation

### Branch Protection & Enforcement

All repositories should implement:

1. **Protected `main` branch** with required PR reviews
2. **Branch name validation** via CI (see [Branch Name Enforcement Workflow](#branch-name-enforcement))
3. **Squash merge** to maintain linear history
4. **Automatic branch deletion** after merge

### Reference Documentation

*Note: Detailed implementation guidelines are consolidated in this handbook. Previous separate documentation files have been superseded by this centralized reference.*

---

## Changelog & Release Automation (client & product)

Automated changelog management and release generation ensures every change is documented and released consistently and traceably. The approach uses GitHub Actions to enforce standards and automate version bumping, changelog updates, and GitHub Releases.

### Pull Request Changelog Requirements

Every PR must include a **structured "Changelog" section** in its description:

```markdown
## Changelog

### Added
- New feature or capability

### Changed  
- Modified existing functionality

### Fixed
- Bug fixes and corrections

### Removed
- Deprecated or removed features
```

### Semantic Versioning with Labels

Version bumping is automated based on PR labels:

- **`release: patch`** → Patch version bump (1.0.0 → 1.0.1)
- **`release: minor`** → Minor version bump (1.0.0 → 1.1.0)  
- **`release: major`** → Major version bump (1.0.0 → 2.0.0)
- **`BREAKING CHANGE:`** in PR description → Major version bump (overrides label)

### Workflow Differences

#### Client Delivery Workflow
- Focuses on traceable releases for client handoffs
- Every merge to `main` triggers a release
- Emphasizes documentation and client communication
- Includes UAT sign-off integration

#### Product Development Workflow  
- Emphasizes continuous deployment
- May include package publishing steps
- Supports multiple release channels (alpha, beta, stable)
- Integration with distribution systems

### Reference Documentation

*Implementation details for both client delivery and product development workflows are specified in the sections below.*

---

## Label Automation Strategy

A comprehensive plan to standardize GitHub labels, automate changelogs, and enforce consistent Git branching workflow across LightSpeed's repositories. This strategy supports our Scrumban process and accommodates both design and development tracks.

### Label Governance

#### Centralized Label Families

We manage a unified set of issue/PR labels, grouped into logical "families":

- **Type/Category Labels:** `bug`, `feature`, `task`, `documentation`, `design`
- **Status Labels:** `status: backlog`, `status: todo`, `status: in-progress`, `status: review`, `status: done`
- **Priority Labels:** `priority: low`, `priority: medium`, `priority: high`, `priority: critical`
- **Area Labels:** `area: frontend`, `area: backend`, `area: infrastructure`, `area: design`
- **Release Labels:** `release: patch`, `release: minor`, `release: major`

#### Central Management

Labels are centrally managed via the LightSpeed `.github` repository with:
- Single source-of-truth configuration
- Automated synchronization across repositories
- Consistent naming, descriptions, and colors
- Prevention of label drift

### Automatic Labeling Rules

GitHub Actions automatically apply labels based on:
- **Branch prefixes** (e.g., `feat/` → `type: feature`)
- **File paths** (e.g., changes in `/docs/` → `area: documentation`)
- **PR content** (e.g., "BREAKING CHANGE" → `release: major`)
- **Issue templates** (pre-populated labels based on issue type)

### Project & Milestone Sync

Integration between labels, projects, and milestones:
- Labels trigger project board updates
- Milestone assignment based on release labels
- Cross-repository project synchronization
- Automated progress tracking

### Reference Documentation

*Label strategy and definitions are detailed in the sections below.*

---

## Issue Types & PR Labelling

Standardized issue types ensure consistent categorization and automation across all LightSpeed repositories.

### Core Issue Types

| Type | Color | Purpose | Example Use Cases |
|------|-------|---------|-------------------|
| 🧩 **Task** | Blue `#4393f8` | General development work | Code implementation, configuration |
| 🐞 **Bug** | Red `#9f3734` | Defects and regressions | Broken functionality, unexpected behavior |
| ✨ **Feature** | Green `#3fb950` | New capabilities | New functionality, enhancements |
| 🎨 **Design** | Purple `#ab7df8` | Design system work | UI/UX updates, design tokens |
| 🧭 **Epic** | Purple `#ab7df8` | Large initiatives | Multi-story projects, major features |
| 📖 **Story** | Blue `#4393f8` | User-focused work | User journey improvements |
| 🔧 **Improvement** | Grey `#9198a1` | Optimizations | Performance, usability improvements |
| ♻️ **Code Refactor** | Grey `#9198a1` | Internal restructuring | Code cleanup, architecture improvements |
| ⚙️ **Build & CI** | Blue `#4393f8` | Infrastructure work | CI/CD, build processes |
| 🤖 **Automation** | Blue `#4393f8` | Process automation | Workflow automation, tooling |

### PR Labelling Automation

PRs are automatically labeled based on:
- **Branch prefix** → **Issue Type** mapping
- **File changes** → **Area** labels  
- **PR template** → **Status** and **Priority** labels
- **Changelog content** → **Release** labels

### Usage Guidelines

- **Every issue/PR** must have exactly **one** Issue Type label
- **Multiple area labels** are allowed when changes span areas  
- **Status labels** track workflow progression
- **Priority labels** help with triage and planning

### Reference Documentation

*Issue types and labelling strategies are covered in the following sections.*

---

## Project Templates (client & product)

Standardized project templates for consistent project management across client delivery and product development workflows.

### Client Delivery Template

**Purpose:** Track client work from intake to UAT and release with lean Scrumban flow.

#### Project Structure
- **Name:** `Client – {ClientName}`
- **Cadence:** Weekly grooming, daily standups, weekly UAT, releases as needed
- **Statuses:** Backlog → Ready → In progress → In review → In QA → Done
- **Focus:** Traceability, client communication, UAT integration

#### Key Fields
- **Status** (Backlog, Todo, In progress, In review, In QA, Done)
- **Issue Type** (Epic, Story, Task, Bug, Chore, Design, Research)  
- **Priority** (Low, Medium, High, Critical)
- **Area** (Frontend, Backend, Design, Content, SEO)
- **Environment** (Development, Staging, Production)
- **Time** (hours estimation)

### Product Development Template

**Purpose:** Support continuous product development with feature planning and release management.

#### Project Structure
- **Name:** `Product – {ProductName}`
- **Cadence:** Sprint planning, daily standups, sprint reviews, continuous releases
- **Statuses:** Backlog → Sprint Ready → In Progress → Review → Testing → Done
- **Focus:** Feature delivery, technical debt management, continuous improvement

#### Key Fields
- **Status** (Backlog, Sprint Ready, In Progress, Review, Testing, Done)
- **Issue Type** (Feature, Bug, Epic, Task, Improvement, Research)
- **Priority** (P0 Critical, P1 High, P2 Medium, P3 Low)  
- **Component** (Core, API, UI, Infrastructure, Documentation)
- **Release** (Next, Future, Backlog)
- **Story Points** (1, 2, 3, 5, 8, 13)

### Automation Integration

Both templates integrate with:
- **Automated labeling** based on issue type and area
- **Branch naming** that maps to project fields
- **Release automation** triggered by project status changes
- **Cross-repository** issue and PR synchronization

### Reference Documentation

*Project template specifications are outlined in the following sections.*

---

## GitHub Actions, Workflows, and Governance

Reusable GitHub Actions workflows and governance policies for consistent automation across the organization.

### Core Workflows

#### Branch Name Enforcement
Validates branch names follow org-wide naming conventions.

**Location:** `.github/workflows/validate-branch-name.yml`

```yaml
name: Validate branch name
on:
  pull_request:
    types: [opened, reopened, synchronize, edited, ready_for_review]
jobs:
  check-branch:
    runs-on: ubuntu-latest
    steps:
      - name: Enforce {type}/{scope}-{short-title}
        run: |
          BRANCH="${{ github.head_ref }}"
          if [[ ! "$BRANCH" =~ ^(feat|fix|docs?|chore|refactor|test|perf|ci|build|release|hotfix)/[a-z0-9._-]+$ ]]; then
            echo "❌ Branch '$BRANCH' must match pattern"
            exit 1
          fi
```

#### Automated Labeling
Applies labels based on branch prefixes and file changes.

**Configuration:** `.github/labeler.yml`

#### Release Automation  
Handles version bumping, changelog generation, and GitHub releases.

**Triggers:** PR merge to main with release labels

#### Label Synchronization
Keeps labels consistent across repositories.

**Schedule:** Weekly or on-demand via workflow dispatch

### Reusable Workflows

Located in `workflows/` directory for organization-wide use:
- **`deploy-wordpress-site.yml`** - WordPress deployment automation
- **`run-tests.yml`** - Standardized testing pipeline

### Shell Script Automation

Key automation scripts in the repository:
- **`sync-labels.sh`** - Synchronize labels across repositories
- **`client_delivery_project.sh`** - Set up client delivery projects
- **`product_dev_project.sh`** - Set up product development projects  
- **`update-projects.sh`** - Bulk update project configurations

### Governance Policies

#### Repository Standards
- All repositories must implement branch protection on `main`
- Required status checks for CI/CD workflows
- Mandatory PR reviews for sensitive branches
- Automated security scanning and dependency updates

#### Workflow Standards
- All workflows must use organization-approved actions
- Secrets management through organization-level secrets
- Consistent environment naming (dev, staging, prod)
- Required workflow approval for deployments

### Reference Documentation

- **Workflow Examples:** [`workflows/`](workflows/) directory
- **Shell Scripts:** [`scripts/`](scripts/) directory  
- **GitHub Templates:** [`.github/`](.github/) directory

---

## Rollout Plan & Quality Gates

Phased implementation approach for organization-wide adoption of automation and governance standards.

### Phase 1: Foundation (Weeks 1-2)

#### Objectives
- Establish central configuration repository
- Implement core label taxonomy  
- Set up branch naming standards

#### Quality Gates
- [ ] Central `.github` repository configured with standard labels
- [ ] Label synchronization tool implemented and tested
- [ ] Branch naming validation workflow deployed to pilot repositories
- [ ] Documentation updated with new standards

#### Success Metrics
- 100% of pilot repositories have consistent labels
- Branch naming compliance > 90% in pilot repositories
- Zero deployment issues with new workflows

### Phase 2: Automation (Weeks 3-4)

#### Objectives
- Deploy automated labeling workflows
- Implement release automation
- Roll out project templates

#### Quality Gates
- [ ] Automated labeling workflows active in all pilot repositories  
- [ ] Release automation successfully generating changelogs and releases
- [ ] Project templates available and documented
- [ ] Training materials created for development teams

#### Success Metrics
- Automated labeling accuracy > 95%
- Release process time reduced by 50%
- Project setup time reduced by 70%

### Phase 3: Organization Rollout (Weeks 5-8)

#### Objectives
- Deploy to all active repositories
- Train all development teams
- Establish monitoring and maintenance processes

#### Quality Gates  
- [ ] All repositories implement standard workflows
- [ ] Development teams trained on new processes
- [ ] Monitoring dashboards operational
- [ ] Maintenance runbooks documented

#### Success Metrics
- 100% repository compliance with standards
- Developer satisfaction score > 4.0/5.0
- Support ticket volume increase < 10%

### Phase 4: Optimization (Ongoing)

#### Objectives
- Gather feedback and iterate
- Optimize workflows based on usage data
- Expand automation capabilities

#### Quality Gates
- [ ] Regular feedback collection from development teams
- [ ] Quarterly review of automation effectiveness
- [ ] Continuous improvement process established
- [ ] Advanced automation features identified and prioritized

#### Success Metrics
- Continuous improvement in developer productivity metrics
- Reduced time-to-market for features and fixes
- Improved code quality and consistency

### Monitoring & Maintenance

#### Key Metrics
- **Workflow Success Rate:** > 99% for critical workflows
- **Label Consistency:** > 98% across all repositories  
- **Branch Naming Compliance:** > 95% organization-wide
- **Release Automation Success:** > 99% for automated releases

#### Maintenance Schedule
- **Daily:** Monitor workflow failures and resolve issues
- **Weekly:** Review metrics and identify improvement opportunities  
- **Monthly:** Update documentation and training materials
- **Quarterly:** Comprehensive review and strategy adjustment

#### Escalation Process
1. **Level 1:** Automated alerts for workflow failures
2. **Level 2:** Team leads notified for compliance issues  
3. **Level 3:** Management escalation for systemic problems
4. **Level 4:** Emergency response for production impacts

### Support & Training

#### Documentation
- **Quick Start Guides** for each workflow type
- **Troubleshooting Guides** for common issues  
- **Video Tutorials** for complex procedures
- **API Documentation** for custom integrations

#### Training Program
- **Onboarding Sessions** for new team members
- **Regular Workshops** on automation best practices
- **Office Hours** for questions and support
- **Certification Program** for automation specialists

---

## Getting Started

### For New Team Members

1. **Read this handbook** to understand our automation and governance standards
2. **Review the branching strategy** and practice branch naming conventions  
3. **Familiarize yourself with issue types** and labeling standards
4. **Set up your development environment** with required tools
5. **Complete the automation training** program

### For Repository Setup

1. **Apply the label synchronization** to get standard labels
2. **Implement branch protection** rules on main branches
3. **Add required workflows** for branch validation and release automation  
4. **Configure project templates** for your team's workflow
5. **Test the complete flow** with a sample PR

### For Automation Engineers

1. **Study the existing workflows** in the `workflows/` directory
2. **Review the shell scripts** in the `scripts/` directory  
3. **Understand the label automation** strategy and implementation
4. **Familiarize yourself with the rollout plan** and quality gates
5. **Join the automation working group** for ongoing improvements

---

## Quick Reference

### Essential Links
- **Repository:** https://github.com/lightspeedwp/scripts/
*All organizational standards and workflows are documented in this consolidated handbook.*
- **Workflows:** [`workflows/`](workflows/) directory  
- **Scripts:** [`scripts/`](scripts/) directory
- **Templates:** [`.github/`](.github/) directory

### Support Contacts
- **Automation Issues:** Create issue in this repository with `automation` label
- **Training Requests:** Contact team leads or use `training` label
- **Emergency Support:** Follow escalation process outlined in rollout plan

### Key Commands
```bash
# Synchronize labels
./sync-labels.sh

# Set up client project  
./client_delivery_project.sh

# Set up product project
./product_dev_project.sh

# Run all tests
./run-tests.sh
```

---

*This handbook is maintained by the LightSpeed automation team. For updates or suggestions, please create an issue or pull request in the [scripts repository](https://github.com/lightspeedwp/scripts/).*