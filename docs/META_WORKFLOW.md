# Meta Workflow

## Purpose

This contract defines how a public, provider-neutral workflow seed becomes an organization-owned internal workflow and then a project-local execution system.

It solves a governance and portability problem:

```text
generic workflow knowledge
    -> safe enterprise import
    -> organization-specific policy
    -> project-specific adoption
    -> bounded task execution
    -> evidence and human acceptance
    -> internal learning and reuse
```

It does not move proprietary project data, operate enterprise infrastructure, or maintain a live synchronization bridge.

## Four scopes

### 1. Public meta-workflow seed

The public repository contains only reusable semantics, templates, and handoff instructions. It may be developed and reviewed outside an enterprise environment because it contains no internal information.

### 2. Internal workflow repository

After handoff, an organization-owned repository becomes authoritative for:

- organization security and access policy;
- approved source-control and tracking providers;
- build and test environments;
- artifact storage;
- branch, review, merge, and release rules;
- internal templates and upgrade decisions.

The internal repository evolves independently.

### 3. Project workflow instance

Each adopted project keeps its own local instructions, Task files, decision log, status index, execution contract, and artifact rules. Organization templates are reconciled with existing project conventions instead of overwriting them.

### 4. Numbered task

A numbered Task MD is the complete specification for one bounded change or experiment. It defines goal, scope, resources, execution authorization, gates, outputs, validation, acceptance, and status semantics.

## Source-of-truth hierarchy

```text
Public seed before handoff
    portable meta contract

Internal workflow repository after handoff
    organization policy and shared templates

Project-local workflow files
    project constraints and conventions

Current Task MD
    one task's complete specification

Provider trackers
    mutable delivery and execution projections

Persistent artifacts
    evidence that execution occurred
```

A lower mutable tracking layer cannot silently redefine a higher versioned contract.

## Lifecycle

### M00 — Freeze a public source

Record an immutable version and full commit SHA. Do not import a moving branch reference as the only provenance.

### M10 — Stage inside the approved boundary

Bring the frozen source into an isolated enterprise staging area. The staged public source remains unchanged and contains no internal customization.

### M20 — Internalize

Generate an organization-owned copy and add the internal profile, security policy, provider mappings, execution environments, and ownership rules.

### M30 — Validate and detach

Verify provenance, completeness, public-boundary separation, internal independence, and disabled reverse synchronization. The internal repository becomes authoritative.

### M40 — Audit a target project

Inspect existing instructions, branches, CI, package management, tests, execution environments, artifacts, trackers, acceptance practices, and conflicts.

### M50 — Reconcile and instantiate

Classify proposed changes as:

- `adopt`: use directly;
- `adapt`: preserve the intent with project-specific implementation;
- `defer`: useful but intentionally postponed;
- `reject`: incompatible or unnecessary.

Create project-local workflow files through a scoped bootstrap task.

### M60 — Validate a pilot

Run one bounded, low-risk end-to-end task through the real project path. Confirm that source identity, execution, artifacts, failure stops, review, merge, and human acceptance are traceable.

### M70 — Evolve internally

Route new knowledge to the narrowest correct scope:

```text
project-only lesson
    -> project repository

organization-wide lesson
    -> internal workflow repository

generic, non-confidential lesson
    -> optional independent public contribution
```

No reverse synchronization is automatic.

## Independent task-level states

Track these dimensions independently:

```text
implementation_status:
    planned | in_progress | merged

execution_status:
    not_run | dry_run | live_success | blocked

artifact_status:
    unavailable | temporary | persistent

live_result_available:
    true | false

human_validation_status:
    not_required | pending | passed | failed | blocked | waived
```

Examples:

```yaml
implementation_status: merged
execution_status: blocked
artifact_status: persistent
live_result_available: false
human_validation_status: blocked
```

```yaml
implementation_status: in_progress
execution_status: live_success
artifact_status: persistent
live_result_available: true
human_validation_status: pending
```

A code merge, pipeline success, tracker status, or machine gate does not imply human acceptance.

## Gate contract

A task may be executed as one bounded unit or projected into gates.

Gate types:

- `machine`: implementation or deterministic execution that an authorized agent may complete after evidence is recorded;
- `approval`: an explicit authorization or merge decision that only an authorized human may complete;
- `human`: semantic, visual, scientific, operational, or release acceptance performed by a human.

Every gate declares:

- stable ID;
- bounded outcome title;
- explicit `depends_on` relations;
- authoritative Task sections;
- execution-environment role when applicable;
- whether an agent may complete it;
- one or more observable exit checks.

Rules:

- dependency order comes only from explicit relations;
- machine completion requires evidence against every exit check;
- failed or blocked gates stop affected downstream paths;
- approval and human gates are never agent-completable;
- parent or delivery closure remains human-controlled when acceptance is pending;
- concurrency defaults to one machine gate unless the Task and resource policy explicitly authorize more.

## Evidence chain

A useful evidence chain preserves identity across environments:

```text
Task contract
    -> source revision
    -> build or execution manifest
    -> immutable artifact identity
    -> test or evaluation manifest
    -> review record
    -> merge or promotion record
    -> human validation result
```

Evidence must be:

- persistent when needed by humans or later tasks;
- linked to the exact source revision and Task;
- factual about commands and actual observations;
- free of credentials and unnecessary private content;
- insufficient by itself to change task scope or acceptance criteria.

## Feedback and compounding value

Workflow value compounds when repeated friction becomes reusable structure:

```text
observed failure
    -> earlier preflight
    -> explicit exit check
    -> test or manifest field
    -> shared internal template
    -> fewer repeated failures
```

Do not promote every local preference to organization policy. Promote only stable, reusable lessons at the correct scope.

## Non-goals

The meta workflow does not:

- select a mandatory platform;
- require a specific tracker or CI system;
- expose enterprise systems to the public repository;
- automate final merge or human acceptance;
- guarantee reproducibility without project-specific contracts;
- replace engineering judgment or research ownership.
