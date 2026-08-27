# Tasks

Task MD files are versioned specifications for bounded workflow changes.

## Naming

```text
TASK_XX_SHORT_NAME.md
TASK_00_WORKFLOW_BOOTSTRAP.md
TASK_00U_WORKFLOW_UPGRADE.md
```

Use stable Task keys. Do not reassign a completed key to unrelated work.

## Source of truth

The Task MD contains complete scope, authorization, gates, evidence, validation, acceptance, and status semantics.

Issues, work items, and gate trackers remain short mutable projections. They link to the Task rather than duplicate it.

## Lifecycle

```text
discussion
    -> Task MD
    -> optional short delivery record
    -> permitted implementation and execution
    -> evidence
    -> review
    -> human merge or delivery
    -> human validation when required
    -> status update
    -> next task
```

## Task creation

Use `TASK_TEMPLATE.md`.

A Task should:

- have one concrete outcome;
- identify its position between prior and next milestones;
- separate allowed and approval-required execution;
- define persistent outputs;
- declare whether gate tracking is used;
- include observable acceptance criteria;
- declare human-validation and closure policy;
- state actual completion semantics.

Do not combine workflow migration, unrelated refactoring, and a new experiment in one Task.
