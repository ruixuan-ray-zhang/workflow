# Provider Adapters

## Purpose

The meta-workflow defines semantic roles. An internal implementation maps those roles to concrete platforms, repositories, trackers, CI systems, servers, and artifact stores.

Task contracts should refer to roles and capabilities rather than hard-code a tool API or current command name.

## Semantic roles

| Role | Responsibility |
|---|---|
| specification repository | Versioned workflow files, project rules, Task MD, decisions, and status |
| delivery tracker | Short delivery record, review linkage, result history, and closure |
| execution tracker | Optional mutable parent/gate state and explicit dependencies |
| change-review provider | Branch, pull request, reviewers, policies, and merge record |
| build executor | Builds an artifact from an identified source revision |
| test executor | Tests or evaluates an identified artifact |
| artifact store | Persists manifests, reports, immutable artifacts, and discovery metadata |
| machine orchestrator | Starts only authorized and eligible machine work |
| human authority | Approves expensive work, merge, release, and semantic acceptance |

One product may implement multiple roles. Roles remain semantically distinct even when stored in the same system.

## Example mappings

### Repository-centered workflow

```text
specification repository: Git repository
delivery tracker: repository issue
execution tracker: optional project-management system
change review: repository pull request
machine orchestrator: CI
artifact store: persistent external storage
human authority: project owner or reviewer
```

### Enterprise workflow with separate source and execution environments

```text
internal workflow repository: enterprise Git host
project source and change review: approved project repository provider
build executor: protected build environment
test executor: protected test environment
artifact store: internal registry and persistent result storage
delivery/execution tracking: approved enterprise tracker or repository-only records
human authority: authorized internal reviewer
```

These are examples, not required products.

## Adapter contract

An adapter declares:

```yaml
provider:
  name: "<provider>"
  stable_project_id: "<internal value>"
  stable_repository_id: "<internal value>"

capabilities:
  create_delivery_record: true
  create_execution_parent: false
  create_gate_children: false
  explicit_dependency_links: false
  create_change_request: true
  publish_machine_status: true
  queue_build: true
  queue_test: true
  persist_artifacts: true
  protected_resource_approval: true
  human_only_final_closure: true
```

Internal values belong only in the internal workflow repository.

## Capability preflight

Before enabling an adapter, verify:

- stable project and repository identities;
- read and write access for each actor;
- explicit dependency representation when gate tracking is used;
- no unsafe parent or child auto-close behavior;
- no merge action granted to machine executors;
- no policy-bypass permission granted to normal agents;
- artifact persistence and discovery;
- exact source revision and artifact identity propagation;
- failure and retry behavior;
- human-only approval and final closure.

If a required capability is absent, use a bounded manual fallback or leave the adapter disabled. Do not pretend materialization or execution occurred.

## Transport independence

A provider may be accessed through:

- a connected tool;
- MCP;
- REST API;
- CLI;
- audited internal script;
- manual UI fallback.

Transport is not part of the Task's scientific or engineering contract. Tool renames or authentication changes should affect the adapter, not rewrite task semantics.

## Build and test identity

For separated build and test environments, preserve:

```text
source revision
    -> build manifest
    -> immutable artifact identity
    -> test manifest
    -> promotion or merge decision
```

The test executor should consume the exact built artifact whenever possible rather than rebuilding it independently.

## Tracker projection

When a tracker is used:

- the Task MD remains authoritative;
- stable Task and gate keys prevent duplicates;
- dependencies are explicit;
- waiting, ready, active, blocked, human, and terminal states are mapped explicitly;
- evidence is preserved across retries;
- omitted active gates are reconciled by a human rather than silently deleted;
- agents do not complete approval gates, human gates, or the parent.

A repository-only workflow remains valid when tracker capabilities are unnecessary.
