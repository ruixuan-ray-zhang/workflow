# Workflow

A portable, provider-neutral **meta-workflow seed** for turning a reusable workflow contract into an organization-owned internal workflow and then into project-local execution rules.

This repository is intended for a one-way lifecycle:

```text
public meta-workflow seed
    -> isolated enterprise import
    -> internal workflow repository
    -> project-specific adoption
    -> task execution and evidence
    -> internal-only evolution
```

After an enterprise handoff, the internal repository becomes authoritative. This public repository is not a runtime dependency, synchronization service, or destination for internal changes.

## Origin

The initial structure was distilled from:

```text
repository: ruixuan-ray-zhang/research-agent-workflow-template
workflow version: 0.3.0
source commit: 56319a04cd1c94e7a8732e111914271fac36b9be
```

The source workflow established several reusable invariants:

- versioned Task MD files are the complete task specification;
- implementation, execution, artifacts, real outputs, and human acceptance are independent states;
- mutable trackers are execution projections, not independent specifications;
- machine gates require explicit dependencies, exit checks, and evidence;
- approval and human gates cannot be completed by an execution agent;
- persistent artifacts provide evidence of real execution;
- workflow adoption and upgrades reconcile local rules rather than overwrite them.

This repository extracts those invariants from their original GitHub/Linear implementation and expresses them as a portable meta structure.

## Authority model

```text
Before handoff:
    this public repository
        -> authoritative for the portable meta contract

After handoff:
    organization-owned internal workflow repository
        -> authoritative for organization policy and shared templates

Within an adopted project:
    project-local Task MD
        -> authoritative for task scope, execution, evidence, and acceptance
```

No automatic upstream synchronization or reverse synchronization is assumed.

## Repository layout

```text
.
├── AGENTS.md
├── README.md
├── VERSION
├── CHANGELOG.md
├── .workflow-meta.yml
├── .github/
│   ├── ISSUE_TEMPLATE/workflow_task.md
│   └── pull_request_template.md
└── docs/
    ├── META_WORKFLOW.md
    ├── ENTERPRISE_HANDOFF.md
    ├── PROVIDER_ADAPTERS.md
    ├── ADOPTION_GUIDE.md
    ├── UPGRADE_GUIDE.md
    ├── HUMAN_VALIDATION.md
    ├── DECISIONS.md
    ├── PROJECT_STATUS.md
    ├── templates/
    │   ├── ENTERPRISE_IMPORT_MANIFEST.yml
    │   ├── INTERNAL_WORKFLOW_PROFILE.yml
    │   ├── TARGET_PROJECT_AUDIT.md
    │   └── PROJECT_ADOPTION_RECORD.yml
    └── tasks/
        ├── README.md
        ├── TASK_TEMPLATE.md
        └── TASK_00_INITIAL_META_EXTRACTION.md
```

## How to use it

### Maintain the public seed

Develop generic, non-confidential workflow improvements here. Record consequential decisions, version the contract, and keep provider-specific behavior behind explicit adapters.

### Internalize it

Follow `docs/ENTERPRISE_HANDOFF.md`. Import a frozen version into an isolated enterprise environment, create an internal profile, validate the handoff, and detach the internal repository from automatic public synchronization.

### Adopt it in a project

Follow `docs/ADOPTION_GUIDE.md`. Audit the target repository, classify each proposed change as `adopt`, `adapt`, `defer`, or `reject`, create a project-local Task 00, and validate one bounded pilot before broader rollout.

## Security boundary

Do not commit organization names, internal URLs, hostnames, network topology, credentials, private paths, source code, datasets, logs, customer information, proprietary model details, or internal policy text to this public repository.

Internal customization happens only after the public seed has crossed the approved enterprise boundary.

## Non-goals

This repository does not:

- connect to an enterprise environment;
- migrate proprietary source code or data;
- implement Azure DevOps, GitHub Enterprise, Linear, Jira, or another provider client;
- operate a background synchronization service;
- automatically merge changes or close human acceptance gates;
- require an internal repository to track future public releases.

See `docs/META_WORKFLOW.md` for the full contract.
