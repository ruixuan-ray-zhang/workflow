# Human Validation

## Purpose

Human validation is the acceptance boundary between successful implementation or execution and permission to rely on the result for the next dependent task.

It answers a different question from machine checks:

```text
Deterministic check:
    Did the specified command or invariant pass?

Execution:
    Did the permitted run complete?

Machine gate:
    Did one bounded checkpoint satisfy its exit checks with evidence?

Human validation:
    Did an authorized human inspect and accept the intended result?
```

## When it is usually required

- real data loading or preprocessing;
- model or method output;
- metrics that affect a decision;
- visualizations and viewers;
- qualitative case studies;
- production-like integration behavior;
- benchmark or system smokes;
- reports whose interpretation enables the next task.

It is often unnecessary for documentation-only edits, formatting fixes, purely synthetic schema tests, and internal refactors with unchanged observable behavior.

The Task MD decides explicitly.

## Status values

```text
not_required  no human acceptance gate applies
pending       implementation or merge completed; validation is unfinished
passed        the human inspected and accepted the result
failed        the inspected result did not meet pass criteria
blocked       validation could not run because a prerequisite was unavailable
waived        the human explicitly proceeded without validation and recorded why
```

## Required task fields

```yaml
human_validation_required: true | false
closure_policy: after_human_validation | on_delivery
blocks_next_task: true | false
```

## Validation packet

A validation-required task provides:

```md
### Commands to run

<Exact commands matching the final implementation.>

### Artifacts to inspect

- <artifact or discovery command>

### Inspection checklist

- [ ] <observable condition>
- [ ] <observable condition>

### Pass criteria

- <clear acceptance condition>

### Expected warnings

- <acceptable warning and rationale>

### Failure handling

- <what becomes a fix task>
- <what blocks the next task>
- <what is informational>
```

Commands and paths must reflect the final implementation and use approved environment variables or discovery methods. Do not guess them from early task prose.

## Closure policy

When validation is not required, the delivery record may close according to project policy after implementation and review complete.

When validation is required:

1. merge or delivery does not close the final task record;
2. set `human_validation_status: pending`;
3. run the validation packet;
4. record actual observations;
5. update project status;
6. close only after `passed` or an explicit `waived` decision.

Machine agents cannot complete the human gate or final parent.

## Result record

```md
## Human validation result

Status: passed | failed | blocked | waived

Commands run:
- <command>

Artifacts inspected:
- <artifact>

Observations:
- <observation>

Blocking issues:
- none | <issue>

Next-step decision:
- proceed | fix required | rerun required | explicitly waived
```

Do not paste credentials, unnecessary private paths, large raw logs, proprietary data, media, tensors, or checkpoints into a tracker.

## Failure handling

- `failed`: create a scoped fix task and stop dependent work;
- `blocked`: resolve the prerequisite or explicitly waive with a reason;
- `waived`: record owner, reason, and remaining claim limitations;
- non-blocking warning: record it and proceed only if pass criteria still hold.

When `blocks_next_task: true`, the next dependent task cannot be finalized as authorized work until validation is `passed` or explicitly `waived`.
