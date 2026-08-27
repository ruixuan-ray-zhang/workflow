# Project Adoption Guide

## Purpose

Adopt an organization-owned internal workflow into an existing project without overwriting intentional project conventions.

The public repository is not used directly after enterprise handoff. The internal workflow repository supplies the approved templates and policy.

## Values to decide

```text
Project name:
Project purpose:
Primary engineering or research question:
Project repository provider:
Default branch:
Integration branch:
Change-review policy:
Developer environment:
Build environment:
Test or evaluation environment:
Persistent artifact location:
Expensive-run policy:
Human validation owner:
Human validation categories:
Tracking mode:
```

## A00 — Audit the existing project

Inspect:

1. existing agent and contributor instructions;
2. branch and merge policy;
3. package manager, lockfiles, and environment setup;
4. CI and deterministic tests;
5. build and packaging flow;
6. test or evaluation environments;
7. artifacts, manifests, and output retention;
8. secrets, data, checkpoints, and private-path policy;
9. issue, work-item, and pull-request conventions;
10. current roadmap and status tracking;
11. human approval and acceptance practices;
12. conflicts with the internal workflow contract.

Use `docs/templates/TARGET_PROJECT_AUDIT.md`.

Do not guess historical execution or acceptance.

## A10 — Reconcile

Classify every proposed change:

- `adopt`: apply the internal rule directly;
- `adapt`: preserve the rule's purpose with a project-specific implementation;
- `defer`: explicitly postpone it and record the trigger for reconsideration;
- `reject`: document why it is incompatible or unnecessary.

Preserve existing scientific, engineering, security, package, test, branch, and artifact rules unless a separate approved decision changes them.

## A20 — Create project-local workflow files

A project should have local equivalents for:

```text
AGENTS.md
workflow adoption metadata
PROJECT_STATUS
DECISIONS
Task template
numbered Task files
execution and artifact contract
human-validation policy
short delivery tracking
```

The exact paths may follow existing project conventions.

Record adoption with `docs/templates/PROJECT_ADOPTION_RECORD.yml`.

## A30 — Create Task 00

Task 00 should implement workflow adoption only.

Do not combine it with:

- broad refactoring;
- new model or algorithm work;
- dataset changes;
- benchmark redesign;
- expensive execution;
- unrelated CI replacement.

Task 00 reports the audit, reconciliation, local deviations, and recommended first operational task.

## A40 — Run a bounded pilot

Choose a low-risk task that exercises the real path:

```text
versioned Task
    -> source change
    -> permitted build or execution
    -> test or evaluation
    -> persistent evidence
    -> review
    -> human merge
    -> optional human validation
```

The pilot should confirm:

- exact source identity is preserved;
- each environment knows its input and output;
- required artifacts persist;
- failures stop downstream work;
- machine evidence is factual;
- merge and final acceptance remain human-controlled;
- project status reflects actual state.

## A50 — Accept adoption

Adoption passes when:

- project rules are explicit;
- conflicts and deviations are recorded;
- Task files are authoritative;
- provider adapters are validated or disabled;
- status dimensions remain independent;
- persistent artifact policy exists;
- expensive work requires authorization;
- human validation is explicit;
- one pilot has completed or a recorded blocker explains why it cannot;
- the project no longer depends on the public seed.

## Tracking

A project may use:

```text
repository_only
parent_only
parent_and_gates
```

Do not create gate children for ordinary edits. Use gates only at meaningful dependency, restart, environment, expensive-run, approval, or human-inspection boundaries.

## Ongoing evolution

Project-local lessons remain local unless they are stable and reusable.

Organization-wide improvements go through the internal workflow repository. Public contributions, when allowed, must be independently rewritten and reviewed to contain no internal information.
