# Task XX — <Short title>

## Goal

<State one concrete outcome and why it is needed now.>

```text
<input or prior milestone>
    -> <bounded change or execution>
    -> <validated output>
    -> <next milestone enabled>
```

## Position in the workflow

<Explain the prior dependency and the next task this enables.>

## Required context

- `AGENTS.md`
- `docs/META_WORKFLOW.md`
- `docs/HUMAN_VALIDATION.md`
- `docs/PROJECT_STATUS.md`
- `docs/DECISIONS.md`
- applicable provider, environment, project, and prior Task documents

Inspect actual repository and environment state rather than relying on memory.

## Assumptions and confirmed resources

List only confirmed resources. Use logical environment roles and approved variables rather than private committed paths.

## Scope

Create or update only:

- `<path or component>`

Explain necessary scope expansion in the delivery record.

## Design requirements

### 1. <Component>

<Behavior, interface, provenance, and validation.>

### 2. <Component>

<Behavior, interface, provenance, and validation.>

## Environment contract

```yaml
source_repository_role: "<role>"
developer_environment_role: "<role>"
build_environment_role: "<role or not_required>"
test_environment_role: "<role or not_required>"
artifact_store_role: "<role>"
```

State the exact identity passed between environments, such as source revision, manifest, immutable artifact digest, dataset version, or run ID.

## Output artifacts

```text
<PERSISTENT_OUTPUT_ROOT>/<task_or_run_id>/
├── manifest.json
├── <machine-readable output>
└── <optional report or visualization>
```

Define required, optional, persistent, private, and committable outputs.

## Execution authorization

```text
Allowed without extra approval:
- <tests, lint, dry-run, bounded build>

Requires explicit approval:
- <expensive run, production resource, paid API, large download, release>
```

Do not execute work outside this authorization.

## Execution tracking

Choose one mode:

```yaml
schema_version: 1

execution_tracking:
  task_key: TASK_XX
  enabled: false
```

```yaml
schema_version: 1

execution_tracking:
  task_key: TASK_XX
  enabled: true
  mode: parent_only
  provider: "<provider adapter>"
```

```yaml
schema_version: 1

execution_tracking:
  task_key: TASK_XX
  enabled: true
  mode: parent_and_gates
  provider: "<provider adapter>"
  max_concurrent_machine_gates: 1
  claim_strategy: single_coordinator
  claim_coordinator: "<one active owner or session>"

gates:
  - id: G00
    title: "<bounded machine outcome>"
    type: machine
    depends_on: []
    environment_role: "<role>"
    task_sections:
      - "<authoritative section>"
    agent_may_complete: true
    exit_checks:
      - "<observable pass condition>"

  - id: G80
    title: "<human approval or merge>"
    type: approval
    depends_on:
      - G00
    environment_role: human_authority
    task_sections:
      - "Delivery requirements"
    agent_may_complete: false
    exit_checks:
      - "<human decision and immutable result are recorded>"

  - id: G90
    title: "<post-delivery human validation>"
    type: human
    depends_on:
      - G80
    environment_role: human_authority
    task_sections:
      - "Human validation"
    agent_may_complete: false
    exit_checks:
      - "<validation passed or was explicitly waived>"
```

Rules:

- stable Task and gate keys do not change after materialization;
- dependencies come only from `depends_on`;
- machine gates require evidence against every exit check;
- approval and human gates are never agent-completable;
- failed or blocked predecessors stop affected paths;
- the provider adapter may not silently delete gates, reset evidence, or close the parent;
- concurrency above one requires independent paths and explicit resource authorization.

## Validation commands

```bash
<copyable deterministic commands>
```

If a command cannot run, report why. Never fabricate success.

## Tests

Verify the happy path, missing prerequisites, malformed input, identity mismatch, non-finite values when relevant, path and privacy safety, determinism, status semantics, failure stops, and existing tests.

## Documentation and status

Update:

- relevant contracts and reports;
- `docs/DECISIONS.md` when a consequential choice changes;
- `docs/PROJECT_STATUS.md`;
- version and changelog when the public or internal contract changes.

Do not mirror every provider gate state into task-level project status.

## Out of scope

Do not:

- <later-stage work>;
- <unapproved expensive work>;
- <broad refactor>;
- <provider or organization policy not authorized by this Task>;
- <unsupported claim>.

## Acceptance criteria

- [ ] <implementation result>
- [ ] <execution result or explicit non-execution>
- [ ] <persistent artifact or evidence result>
- [ ] <identity and provenance requirement>
- [ ] <privacy and authority requirement>
- [ ] Project status is accurate.

## Completion semantics

```yaml
implementation_complete_when:
  - <condition>

execution_complete_when:
  - <condition>

artifact_complete_when:
  - <condition>

tracking_complete_when:
  - <projection validated or not required>
```

State whether implementation may be delivered while live execution remains blocked.

## Human validation

```yaml
human_validation_required: <true | false>
closure_policy: <after_human_validation | on_delivery>
blocks_next_task: <true | false>
```

When required, provide the final packet.

### Commands to run

```bash
<exact commands matching the final implementation>
```

### Artifacts to inspect

- `<artifact or discovery command>`

### Inspection checklist

- [ ] <observable condition>

### Pass criteria

- <condition>

### Expected warnings

- <acceptable warning>

### Failure handling

- <fix task, rerun, blocker, or informational handling>

## Expected status transition

Before work:

```yaml
implementation_status: planned
execution_status: not_run
artifact_status: unavailable
live_result_available: false
human_validation_status: <not_required | pending-after-delivery>
```

After delivery, record actual states. Human validation remains `pending` until the authorized human resolves it.

## Delivery requirements

Report:

- Task and tracking links;
- changed files or components;
- actual commands and checks;
- source, artifact, and run identities;
- actual status values;
- persistent evidence;
- blockers and next step;
- human-validation packet when required;
- whether the delivery record remains open;
- confirmation that no agent completed an approval gate, human gate, or final parent.
