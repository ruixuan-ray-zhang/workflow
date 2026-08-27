# Task 00 — Initial Meta-Workflow Extraction

## Goal

Initialize `ruixuan-ray-zhang/workflow` as a public, provider-neutral meta-workflow seed distilled from the reusable invariants of `research-agent-workflow-template` v0.3.0.

```text
research-specific workflow contract
    -> identify reusable invariants
    -> remove provider and organization binding
    -> define one-way enterprise handoff
    -> publish a portable public seed
```

## Source provenance

```text
source repository: ruixuan-ray-zhang/research-agent-workflow-template
source workflow version: 0.3.0
source commit: 56319a04cd1c94e7a8732e111914271fac36b9be
target repository: ruixuan-ray-zhang/workflow
initial target version: 0.1.0
```

## Extracted invariants

- Task MD is the complete bounded specification.
- Mutable trackers are execution projections.
- Implementation, execution, artifacts, live results, and human acceptance are independent.
- Machine gates require explicit dependencies, exit checks, and evidence.
- Approval and human gates are not agent-completable.
- Persistent artifacts provide execution provenance.
- Adoption and upgrades reconcile rather than overwrite.
- Dependent work stops on unresolved required gates.

## New meta-level contract

Add:

- public seed, internal workflow, project instance, and numbered-task scopes;
- one-way detached enterprise handoff;
- authority transfer to the internal repository;
- provider-role adapters;
- public-boundary and no-reverse-sync policy;
- enterprise import and project-adoption templates.

## Scope

Create the initial repository structure documented in `README.md`.

## Out of scope

Do not:

- connect to an enterprise system;
- include organization-specific information;
- implement a provider client;
- migrate proprietary source code or data;
- configure build or test servers;
- create a background synchronization service;
- change the source research workflow repository.

## Validation

Verify:

- every referenced file exists;
- `VERSION` is `0.1.0`;
- source version and commit are recorded consistently;
- public and internal authority are unambiguous;
- reverse synchronization is disabled;
- provider-specific products are examples or adapters, not core requirements;
- no organization-specific or proprietary information is present;
- Task, status, gate, evidence, handoff, and human-validation semantics agree;
- formatting and repository rendering are valid.

## Acceptance criteria

- [x] A focused public meta-workflow repository exists.
- [x] One-way enterprise handoff is documented.
- [x] Internal authority after handoff is explicit.
- [x] Provider-neutral roles replace GitHub/Linear binding.
- [x] Independent status and human-validation semantics are retained.
- [x] Enterprise import and project-adoption templates exist.
- [x] Public-boundary rules prohibit internal information.
- [x] No runtime public/internal synchronization is introduced.

## Completion semantics

```yaml
implementation_status: merged
execution_status: not_run
artifact_status: persistent
live_result_available: false
human_validation_status: not_required
```

The target repository was empty, so this bootstrap initializes `main` directly. Future non-trivial changes should use a numbered Task, short issue, reviewed pull request, status update, and human merge.
