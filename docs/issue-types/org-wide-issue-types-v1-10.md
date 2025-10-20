# **Issue Types Guide**

***Version:*** 1.10 • ***Last updated:*** 17 Oct 2025
***Scope:*** WordPress themes, plugins, blocks, WooCommerce, FSE projects  
***Purpose:*** A practical, organisation-wide reference for **Issue Types** usage.  
---

[0\) How to use this guide](#0\)-how-to-use-this-guide)

[1\) Issue Types](#1\)-issue-types)

[🧩 Task — Blue \#4393f8](#🧩-task-—-blue-#4393f8)

[🐞 Bug — Red \#9f3734](#🐞-bug-—-red-#9f3734)

[✨ Feature — Green \#3fb950](#✨-feature-—-green-#3fb950)

[🎨 Design — Purple \#ab7df8](#🎨-design-—-purple-#ab7df8)

[🧭 Epic — Purple \#ab7df8](#🧭-epic-—-purple-#ab7df8)

[📖 Story — Blue \#4393f8](#📖-story-—-blue-#4393f8)

[🔧 Improvement — Grey \#9198a1](#🔧-improvement-—-grey-#9198a1)

[♻️ Code Refactor — Grey \#9198a1](#♻️-code-refactor-—-grey-#9198a1)

[⚙️ Build & CI — Blue \#4393f8](#⚙️-build-&-ci-—-blue-#4393f8)

[🤖 Automation — Blue \#4393f8](#🤖-automation-—-blue-#4393f8)

[🧪 Test Coverage — Yellow \#d29922](#🧪-test-coverage-—-yellow-#d29922)

[⚡ Performance — Yellow \#d29922](#⚡-performance-—-yellow-#d29922)

[♿ A11y — Pink \#db61a2](#♿-a11y-—-pink-#db61a2)

[🔒 Security — Red \#9f3734](#🔒-security-—-red-#9f3734)

[🔌 Compatibility — Orange \#8d4821](#🔌-compatibility-—-orange-#8d4821)

[🔄 Integration — Orange \#8d4821](#🔄-integration-—-orange-#8d4821)

[🚀 Release — Green \#3fb950](#🚀-release-—-green-#3fb950)

[🧰 Maintenance — Grey \#9198a1](#🧰-maintenance-—-grey-#9198a1)

[📚 Documentation — Grey \#9198a1](#📚-documentation-—-grey-#9198a1)

[🔬 Research — Grey \#9198a1](#🔬-research-—-grey-#9198a1)

[🧹 Chore — Grey \#9198a1](#🧹-chore-—-grey-#9198a1)

[🧾 Audit — Grey \#9198a1](#🧾-audit-—-grey-#9198a1)

[👀 Code Review — Blue \#4393f8](#👀-code-review-—-blue-#4393f8)

[🧠 AI Ops — Blue \#4393f8](#🧠-ai-ops-—-blue-#4393f8)

[🗂️ Content Modelling — Purple \#ab7df8](#🗂️-content-modelling-—-purple-#ab7df8)

[3\) Saved searches (pin in Projects)](#3\)-saved-searches-\(pin-in-projects\))

[4\) Notes & guardrails](#4\)-notes-&-guardrails)

---

# **0\) How to use this guide** {#0)-how-to-use-this-guide}

**Important:**

- **Pick one Issue Type** per issue for classification.  
  - Add routing labels: **Priority \+ Status \+ Area/Component**  
  - Then add **Lang/Env/Compat/CPT** as needed.  
- Each section in the document below describes:   
  - **Description**  
  - **Why (colour)**  
  - **Use when**  
  - **Relevant labels**  
  - **Process**  
  - **DoR/DoD add‑ons**.

**Issue Type colour palette:**

- Grey `#9198a1`   
- Blue `#4393f8`   
- Green `#3fb950`   
- Yellow `#d29922`   
- Orange `#8d4821`   
- Red `#9f3734`   
- Pink `#db61a2`   
- Purple `#ab7df8`

---

# **1\) Issue Types** {#1)-issue-types}

## **🧩 Task — *Blue `#4393f8`*** {#🧩-task-—-blue-#4393f8}

**Description:**  
Small, well‑scoped unit of work: adjust a template part, update `theme.json` tokens, tweak CI, add a block setting, write a micro‑migration, or tidy copy. Typically ≤2 days with minimal discovery.

**Why blue?**  
Operational engineering execution.

**Use when**

- Concrete scope; clear AC and owner  
- No significant research/design needed

**Relevant labels**

- `priority:normal`  
- `status:ready` → `status:in-progress` → `status:needs-review` → `status:needs-qa`  
- `comp:block-editor|design-system|ci|deployment|dependencies` (as applicable)  
- `comp:block-templates|template-parts|block-patterns|theme-json|spacing|typography|color-palette`  
- `lang:php|js|css|html|md|json|yaml`   
- `env:staging|live`   
- `cpt:posts|pages`   
- `meta:has-pr`

**Process (typical flow)**  
Pick up from Ready → Implement → PR & review → QA/verify → Done.

**DoR add-ons for Task**  
AC; owner; impacted files; rollback note.

**DoD add-ons for Task / PR**  
Tests/docs updated; screenshots; changelog if user‑visible.

---

## **🐞 Bug — *Red `#9f3734`*** {#🐞-bug-—-red-#9f3734}

**Description:**  
Broken/incorrect behaviour: PHP errors, block render issues, CSS regressions, JS console errors, REST faults, Woo checkout breakage. Provide repro steps, expected/actual, and affected environment(s).

**Why red?**  
Risk and impact.

**Use when**

- Production/UAT regressions or spec deviations  
- Affects user outcomes or data integrity

**Relevant labels**

- `priority:critical|important|normal|minor`   
- `status:needs-testing|in-progress|needs-review|needs-qa`   
- `status:blocked` (if applicable)  
- `env:prototype|staging|live`   
- `compat:wordpress|php|gutenberg|woocommerce|rtl`  
- `comp:block-editor` (as applicable)  
- `comp:block-templates|template-parts|block-json|theme-json|wp-admin|settings|post-settings|block-inserter`  
- `lang:php|js|css`   
- `cpt:posts|pages`   
- `meta:has-pr`

**Process (typical flow)**  
Reproduce → Fix on branch → PR → Verify in CI/UAT → Release note.

**DoR add-ons for Bug**  
Repro steps; scope; env matrix; error/logs.

**DoD add-ons for Bug / PR**  
Regression tests; release notes; monitors/alerts checked.

---

## **✨ Feature — *Green `#3fb950`*** {#✨-feature-—-green-#3fb950}

**Description:**  
Net‑new capability: new block/pattern, screen, API, or editorial workflow. Includes design/spec, implementation, review, QA and rollout plan across environments.

**Why green?**  
Delivery and customer value.

**Use when**

- A new user‑facing outcome is introduced  
- Requires design & engineering coordination

**Relevant labels**

- `priority:important|normal`   
- `status:needs-design|needs-dev|ready|in-progress|needs-review|needs-qa`   
- `status:needs-figma-update` (if tokens changed)  
- `comp:theme-json|block-templates|template-parts|block-patterns|block-variations|block-styles|style-variations|typography|color-palette|section-styles|spacing`  
- `area:design-system`   
- `compat:*`   
- `env:staging` then `env:live`   
- `lang:*`   
- `cpt:*`  
- `meta:has-pr`

**Process (typical flow)**  
Define spec → Design sign‑off → Build → Review → QA → Release.

**DoR add-ons for Feature**  
Story; non‑functional budgets (perf/a11y/security); migration flags.

**DoD add-ons for Feature / PR**  
Docs & changelog; feature flags/toggles noted; rollout/rollback steps.

---

## **🎨 Design — *Purple `#ab7df8`*** {#🎨-design-—-purple-#ab7df8}

**Description:**  
Design artefacts/decisions: UX flows, wireframes, hi‑fi Figma, block/pattern specs, `theme.json` tokens, component states, microcopy, a11y checks, and developer handoff notes.

**Why purple?**  
Planning/specification that guides delivery.

**Use when**

- Output is design/spec rather than code  
- Decisions must be captured before implementation

**Relevant labels**

- `status:needs-design`   
- `status:needs-design-review`   
- `status:needs-figma-update`  
- `area:design-system`  
- `comp:theme-json|block-styles|style-variations|typography|color-palette|section-styles|spacing|block-templates|template-parts|block-patterns`  
- `cpt:*` (if modelling content)

**Process (typical flow)**  
Brief → Explorations → Review → Final spec → Handoff.

**DoR add-ons for Design**  
Problem statement; user goals; constraints; a11y criteria; impacted components.

**DoD add-ons for Design / PR**  
Figma links; annotated specs; token diffs; handoff checklist complete.

---

## **🧭 Epic — *Purple `#ab7df8`*** {#🧭-epic-—-purple-#ab7df8}

**Description:**  
Parent issue grouping stories/tasks across repos to realise a larger outcome. Defines scope, timebox, and KPIs. Tracks progress via linked child issues and milestones.

**Why purple?**  
Strategic structure and planning.

**Use when**

- Multiple issues must land for one outcome  
- You need roll‑up progress and shared KPIs

**Relevant labels**

- `priority:*`   
- `area:*`   
- optional `compat:*`   
- `env:*` for scoped rollouts   
- `meta:stale` (guard long‑running epics)

**Process (typical flow)**  
Create epic → Draft stories → Link children → Track roll‑up progress → Close.

**DoR add-ons for Epic**  
Outcome/KPIs; milestone; child plan; risks/dependencies; stakeholders.

**DoD add-ons for Epic / PR**  
All children closed; KPI target met/reviewed; notes captured.

---

## **📖 Story — *Blue `#4393f8`*** {#📖-story-—-blue-#4393f8}

**Description:**  
User‑centred vertical slice within an Epic. Delivers a demonstrable capability with acceptance criteria, ready for UAT and release when verified.

**Why blue?**  
Engineering execution tied to outcomes.

**Use when**

- Clear AC; fits iteration; linked to Epic  
- End‑to‑end demo is feasible

**Relevant labels**

- `priority:normal`  
- `status:ready|in-progress|needs-review|needs-qa`  
- `area:*`  
- `comp:*`   
- `lang:*`  
- `env:staging→live`   
- `cpt:*`   
- `meta:has-pr`

**Process**  
Build → Review → QA → Demo → Done.

**DoR add-ons**  
AC; design refs; risks.

**DoD add-ons**  
Demo evidence; docs updated; Epic progress noted.

---

## **🔧 Improvement — *Grey `#9198a1`*** {#🔧-improvement-—-grey-#9198a1}

**Description:**  
Enhance existing behaviour or UX without adding a new feature. Examples: copy, validation, empty states, small editor polish, incremental UI consistency.

**Why grey?**  
Quality uplift, low risk.

**Use when**

- Scope is contained and user‑visible  
- No schema/API changes required

**Relevant labels**

- `status:ready|in-progress|needs-review|needs-qa`   
- `area:*`  
- `comp:*`   
- `lang:*`   
- `cpt:*`

**Process**  
Scope → Implement → Light review/QA.

**DoR add-ons**  
Before/after; success measure.

**DoD add-ons**  
Screenshots; no regressions.

---

## **♻️ Code Refactor — *Grey `#9198a1`*** {#♻️-code-refactor-—-grey-#9198a1}

**Description:**  
Internal restructure to improve readability/testability/maintainability without changing behaviour. Ideal for paying down technical debt and preparing for features.

**Why grey?**  
Hygiene/maintainability.

**Use when**

- Behaviour must remain identical  
- Improves complexity/coverage/perf potential

**Relevant labels**

- `status:in-progress|needs-review`   
- `area:*`  
- `comp:*`   
- `lang:*`   
- `meta:stale` (guard long branches)

**Process**  
Safe refactor → Tests → Merge.

**DoR add-ons**  
Risk notes; blast radius; test plan.

**DoD add-ons**  
Coverage stable/↑; changelog N/A or internal.

---

## **⚙️ Build & CI — *Blue `#4393f8`*** {#⚙️-build-&-ci-—-blue-#4393f8}

**Description:**  
Tooling, pipelines, packaging, releases, deploys. Includes actions, test runners, caching, matrix builds, and release automation.

**Why blue?**  
Engineering operations and enablement.

**Use when**

- Changing CI workflows or deployment steps  
- Release engineering and artefacts

**Relevant labels**

- `area:ci|deployment|dependencies`   
- `status:in-progress|needs-review|needs-technical-feedback`  
- `env:staging`   
- `compat:php|wordpress`   
- `meta:no-issue-activity|no-pr-activity`

**Process**  
Propose → Test → Rollout.

**DoR add-ons**  
Rollback plan; secrets/permissions.

**DoD add-ons**  
Pipelines green; docs updated.

---

## **🤖 Automation — *Blue `#4393f8`*** {#🤖-automation-—-blue-#4393f8}

**Description:**  
Bots/actions/scripts that reduce toil: labelers, sync scripts, scaffolding, changelog generators, stale‑sweeps.

**Why blue?**  
Ops & engineering automation.

**Use when**

- Automating repeatable tasks  
- Improving signal/triage

**Relevant labels**

- `area:ci|dependencies`   
- `status:ready|in-progress|needs-review`   
- `meta:has-pr|stale|no-issue-activity|no-pr-activity`   
- `ai-ops:tools` (if AI‑assisted)

**Process**  
Define trigger → Dry‑run → Enable.

**DoR add-ons**  
Permissions; failure modes.

**DoD add-ons**  
Logs verified; audit notes.

---

## **🧪 Test Coverage — *Yellow `#d29922`*** {#🧪-test-coverage-—-yellow-#d29922}

**Description:**  
Add or expand tests: unit, integration, E2E. Raise confidence and guard regressions across blocks, templates, and PHP APIs.

**Why yellow?**  
Quality signalling.

**Use when**

- Increasing test confidence/coverage  
- Validating fixes or features

**Relevant labels**

- `status:needs-testing|needs-qa|in-progress`   
- `area:*`  
- `comp:*`   
- `env:staging`   
- `compat:*`   
- `lang:js|php`

**Process**  
Plan → Implement → Report.

**DoR add-ons**  
Fixtures; env matrix.

**DoD add-ons**  
Coverage delta; CI green.

---

## **⚡ Performance — *Yellow `#d29922`*** {#⚡-performance-—-yellow-#d29922}

**Description:**  
Improve speed/efficiency: render and bundle sizes, query counts, LCP/CLS, lazy‑loading, asset strategy. Must include a baseline and target.

**Why yellow?**  
Quality budgets & measurable gains.

**Use when**

- Perf is the primary goal  
- Metrics & thresholds are defined

**Relevant labels**

- `status:in-progress|needs-review|needs-qa`   
- `area:*`  
- `comp:*`   
- `compat:wordpress|php`   
- `env:staging`   
- `lang:*`

**Process**  
Baseline → Optimise → Measure → Ship.

**DoR add-ons**  
Targets and method.

**DoD add-ons**  
Metrics improved; notes logged.

---

## **♿ A11y — *Pink `#db61a2`*** {#♿-a11y-—-pink-#db61a2}

**Description:**  
Accessibility to WCAG 2.1 AA: semantics, focus, contrast, keyboard paths, screen reader support. Includes audits, fixes, and verification.

**Why pink?**  
Inclusion and accessibility.

**Use when**

- Auditing/fixing a11y issues  
- Validating design/implementation

**Relevant labels**

- `status:ready|in-progress|needs-qa`   
- `area:design-system`   
- `comp:block-templates|block-patterns|template-parts|typography|spacing|section-styles|theme-json|block-json`  
- `comp:block-editor`  
- `cpt:*`   
- `env:staging`

**Process**  
Audit → Fix → Verify.

**DoR add-ons**  
Criteria & AT matrix.

**DoD add-ons**  
Checklist \+ screenshots.

---

## **🔒 Security — *Red `#9f3734`*** {#🔒-security-—-red-#9f3734}

**Description:**  
Hardening and fixes: sanitise/escape, nonces, capabilities, dependency CVEs, secrets handling, permission checks. Confidential handling as needed.

**Why red?**  
Risk mitigation.

**Use when**

- Vulnerability identified or posture work  
- Security reviews/certifications

**Relevant labels**

- `priority:critical|important`   
- `status:in-progress|needs-review`   
- `area:dependencies`   
- `compat:php|wordpress`   
- `env:*`   
- `meta:stale` (time‑boxed follow‑ups)

**Process**  
Assess → Patch → Verify → Release.

**DoR add-ons**  
Threat & impact notes.

**DoD add-ons**  
Tests; disclosure plan (if needed).

---

## **🔌 Compatibility — *Orange `#8d4821`*** {#🔌-compatibility-—-orange-#8d4821}

**Description:**  
Work to align with version/platform constraints: WordPress/Gutenberg updates, PHP min/tested‑up‑to, Woo compatibility, RTL support.

**Why orange?**  
External dependencies and support matrix.

**Use when**

- Platform changes or policy updates  
- Support/upgrade matrix tasks

**Relevant labels**

- `compat:wordpress|php|woocommerce|rtl|gutenberg`  
- `status:ready|in-progress`  
- `env:staging`  
- `meta:has-pr`

**Process**  
Define matrix → Test/fix → Document.

**DoR add-ons**  
Target matrix; risks.

**DoD add-ons**  
Readme “tested up to”; CI matrix green.

---

## **🔄 Integration — *Orange `#8d4821`*** {#🔄-integration-—-orange-#8d4821}

**Description:**  
Integrating external plugins/services/APIs (payments, search, analytics). Includes sandboxing, fail‑path handling, logging and observability.

**Why orange?**  
External surface area and contracts.

**Use when**

- New/updated 3rd‑party integration  
- Requires keys/scopes and error handling

**Relevant labels**

- `area:integration|deployment`   
- `status:in-progress|needs-review|needs-qa`   
- `env:staging|live`   
- `compat:*`   
- `meta:has-pr`

**Process**  
Sandbox → Implement → Fail‑path tests → Live.

**DoR add-ons**  
Keys/secrets; flows.

**DoD add-ons**  
Logs/tracing \+ docs.

---

## **🚀 Release — *Green `#3fb950`*** {#🚀-release-—-green-#3fb950}

**Description:**  
Plan, cut and ship a release/hotfix. Coordinates changelog, tagging, deployment, and comms. Serves as the shipping record for environments.

**Why green?**  
Delivery signal.

**Use when**

- Preparing a release or hotfix  
- Coordinating deploy, notes and comms

**Relevant labels**

- `status:ready|needs-review`   
- `env:staging|live`   
- `area:deployment`   
- `meta:has-pr`   
- `compat:*`

**Process**  
Candidate → QA → Tag → Deploy → Announce.

**DoR add-ons**  
Scope/date; owners.

**DoD add-ons**  
Tag \+ notes; monitoring.

---

## **🧰 Maintenance — *Grey `#9198a1`*** {#🧰-maintenance-—-grey-#9198a1}

**Description:**  
Routine upkeep: dependency bumps, lint/format, small housekeeping. Low risk but keeps repos healthy and secure.

**Why grey?**  
Hygiene work.

**Use when**

- Keeping things current  
- No behaviour change

**Relevant labels**

- `status:ready|in-progress`   
- `area:dependencies|ci`   
- `env:staging`   
- `compat:*`   
- `meta:no-issue-activity|no-pr-activity`

**Process**  
Batch → Verify → Merge.

**DoR add-ons**  
Change list; risk level.

**DoD add-ons**  
CI green; smoke test.

---

## **📚 Documentation — *Grey `#9198a1`*** {#📚-documentation-—-grey-#9198a1}

**Description:**  
Docs & guides for developers, editors, or contributors. Includes READMEs, user docs, saved replies, and in‑repo handbooks.

**Why grey?**  
Knowledge, not code.

**Use when**

- Documentation is the deliverable  
- Explaining changes or processes

**Relevant labels**

- `status:needs-more-info|needs-review|ready`   
- `lang:md|json|yaml|html`   
- `comp:*`   
- `ai-ops:instructions|prompts|chat-modes`   
- `meta:has-pr`

**Process**  
Draft → Review → Publish.

**DoR add-ons**  
Audience; outline.

**DoD add-ons**  
Links from README/wiki; docs build if any.

---

## **🔬 Research — *Grey `#9198a1`*** {#🔬-research-—-grey-#9198a1}

**Description:**  
Time‑boxed exploration to reduce uncertainty: compare approaches, PoC a pattern, validate feasibility, or gather metrics to decide a direction.

**Why grey?**  
Learning and risk reduction.

**Use when**

- Decision support is required  
- Time‑box and questions are clear

**Relevant labels**

- `status:in-discussion|on-hold`   
- `env:prototype`   
- `comp:*`   
- `ai-ops:*` (if researching prompts/agents)   
- `meta:stale`

**Process**  
Question/time‑box → Explore → Report.

**DoR add-ons**  
Hypothesis; success test.

**DoD add-ons**  
Findings; follow‑ups filed.

---

## **🧹 Chore — *Grey `#9198a1`*** {#🧹-chore-—-grey-#9198a1}

**Description:**  
Small housekeeping: file moves, ignore rules, repo settings, GH Actions tweaks. Quicker than Tasks; often unblocks other work.

**Why grey?**  
Low‑risk hygiene.

**Use when**

- Quick clean‑ups  
- Non‑functional tidies

**Relevant labels**

- `status:ready|in-progress|needs-review`   
- `area:ci|dependencies`   
- `meta:no-issue-activity|no-pr-activity`   
- `contrib:good-first-issue` (if suitable)

**Process**  
Quick change → Review → Merge.

**DoR add-ons**  
Tiny scope; owner.

**DoD add-ons**  
Verified; no side effects.

---

## **🧾 Audit — *Grey `#9198a1`*** {#🧾-audit-—-grey-#9198a1}

**Description:**  
Structured review of current state, producing findings and actions: a11y, performance, security, content, or SEO audits.

**Why grey?**  
Assessment to drive follow‑ups.

**Use when**

- Establishing baseline or gaps  
- Creating a targeted action list

**Relevant labels**

- `status:in-progress`   
- `area:*`   
- `priority:*`   
- `compat:*`   
- `env:staging`   
- `meta:stale`

**Process**  
Scope → Review → Report → File actions.

**DoR add-ons**  
Criteria/tools; sampling.

**DoD add-ons**  
Report \+ actions list.

---

## **👀 Code Review — *Blue `#4393f8`*** {#👀-code-review-—-blue-#4393f8}

**Description:**  
Focused review tasks not tied to a single PR (cross‑cutting, security sweeps, migration reviews) or formal approvals on complex changes.

**Why blue?**  
Engineering assurance.

**Use when**

- Formal review is required  
- Cross‑cutting reviews or approvals

**Relevant labels**

- `status:needs-review`   
- `lang:*`   
- `comp:*`   
- quality areas via `compat:*` or `area:*`

**Process**  
Request → Review → Approve/changes → Merge.

**DoR add-ons**  
PR links; review asks.

**DoD add-ons**  
Approvals; follow‑ups filed.

---

## **🧠 AI Ops — *Blue `#4393f8`*** {#🧠-ai-ops-—-blue-#4393f8}

**Description:**  
Manage AI assets and workflows: instructions, prompts, chat modes, agents, datasets, evaluations and tools that live in the repo.

**Why blue?**  
Engineering operations for AI systems.

**Use when**

- Curating AI artefacts/ops  
- Establishing evaluation loops

**Relevant labels**

- `status:in-progress|needs-review`   
- `ai-ops:instructions|prompts|chat-modes|agents|datasets|evaluations|tools`   
- `lang:md|json|yaml`   
- `area:design-system` (if UX surfacing)

**Process**  
Draft → Review (legal/eng) → Publish → Iterate.

**DoR add-ons**  
Risks/governance.

**DoD add-ons**  
Versioned; rollout notes.

---

## **🗂️ Content Modelling — *Purple `#ab7df8`*** {#🗂️-content-modelling-—-purple-#ab7df8}

**Description:**  
Define post types/taxonomies/fields and map to templates/patterns. Aligns with editor experience, tokens, and migrations for authoring at scale.

**Why purple?**  
Information architecture & design decisions.

**Use when**

- New build or major restructure  
- Mapping content → templates/patterns

**Relevant labels**

- `status:in-discussion|ready`   
- `cpt:*`  
- `comp:block-templates|template-parts|block-patterns|theme-json|color-palette|typography|spacing`   
- `env:staging`

**Process**  
Audit → IA → Model → Template map → Review → Handoff.

**DoR add-ons**  
Goals/constraints; migration notes.

**DoD add-ons**  
Schema approved; redirects in place.

---

# **3\) Saved searches (pin in Projects)** {#3)-saved-searches-(pin-in-projects)}

- Engineers’ queue: `is:open is:issue label:"status:ready" -label:"status:blocked" sort:updated-desc`  
- QA sweep: `is:open label:"status:needs-qa"`  
- Release gate (vX.Y): `is:open milestone:vX.Y`

---

# **4\) Notes & guardrails** {#4)-notes-&-guardrails}

- Don’t over‑use types—prefer **labels** for orthogonal concerns (priority, status, area).  
- “Design” → implementation: either convert to **Feature/Task** or link child **Stories**.  
- “Story” stays child of an **Epic**; track progress via parent roll‑up in Projects.

---

*This Issue Types standard extends the LightSpeed Projects/Issues/Labels strategy.* *Aligned with our **Labels Guide v1.10** and **Projects/Issues/Milestones strategy v1.2**.*