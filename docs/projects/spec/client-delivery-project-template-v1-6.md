# Project Settings — Client Delivery

**Date:** 13-10-2025 — **Version:** v1.6

> Use `{}` to indicate placeholders (e.g., `Client – {ClientName}`).

## Project name

`Client – {ClientName}`

## Short description

**Rule:** one sentence, ≤160 characters.  
**Default:** `Track client work from intake to UAT and release using a lean Scrumban flow.`

## README

### Purpose

Track client work from intake to UAT and release with a lean Scrumban flow.

### Status columns

Backlog → To-do → In progress → In review → In QA → Done

### Views

- **Board (by Assignee)** — _board_  
  Group by **Assignee** · Sort **Priority desc** · **Field sum:** Estimate

- **Backlog (Priority)** — _table_  
  Filter **Status = Backlog** · Sort **Priority desc, Size asc** _(Size uses numeric prefixes to enforce order)_ · **Field sum:** Estimate

- **QA Gate** — _table_  
  Filter **Status ∈ {In review, In QA}** · **Group by Environment** · Sort **Severity desc, Priority desc**

- **UAT (Staging)** — _table_  
  Filter **Environment = Staging** AND **Status ∈ {In review, In QA}**

- **Epics — Tracking (Table)** — _table_  
  Filter **Issue Type = Epic** · Group by **Phase** · Sort **Priority desc**

- **Epics — Roadmap (Table)** — _table_  
  Filter **Issue Type = Epic** · Group by **Theme** · Sort **Phase, Priority**

- **Epics — Board** — _board_  
  Filter **Issue Type = Epic** · Group by **Status**

- **Roadmap (Dates)** — _roadmap_  
  Start field = **Start Date** · Target field = **Deadline** · Group by **Theme**

- **Blocked** — _table_  
  Filter **Label = blocked** OR **Status note contains "blocked"**

### Automations

- On item added → **Status = Backlog**
- On assignee set → **Status = In progress**
- On PR opened → **Status = In review**
- On label `status:needs-qa` → **Status = In QA**
- On PR merged / issue closed → **Status = Done**

### Cadence

- Weekly grooming (prioritise **High**, then **Medium**)
- Daily stand-up (focus on **Blocked** view)
- UAT every Thursday; ship as needed
- _(Optional)_ Mid-week triage; fortnightly show-and-tell; monthly retro

### Field defaults

- **Priority:** **Medium** (default)
- **Phase:** **Pre-launch** (default)
- **Environment:** **Staging** (default)
- **Size:** **0 – Unknown** (default)
- **Theme, Area:** set at triage (choose exactly **one** Theme per item)
- **Estimate/Start Date/Deadline:** set when scheduled
- **Milestone (Iteration):** optional for client windows (e.g., UAT-1, Go-Live)

### Definition of Ready (DoR) — Checklist

- [ ] Problem statement and outcome defined
- [ ] Acceptance criteria written (Given/When/Then)
- [ ] Designs or references attached (if relevant)
- [ ] Dependencies identified and unblocked
- [ ] Estimates agreed (Size and/or hours)
- [ ] Test approach noted (how we’ll verify)
- [ ] Stakeholders and approver listed
- [ ] Environment clarified (Prototype/Staging/Live)

### Definition of Done (DoD) — Checklist

- [ ] Acceptance criteria met
- [ ] Unit/functional tests added or updated
- [ ] A11y pass (key flows and components)
- [ ] Docs updated (README/Changelog/Client notes)
- [ ] Feature toggles/rollout considered
- [ ] QA verified on Staging
- [ ] UAT approved by client (if applicable)
- [ ] Release notes prepared; monitoring in place
