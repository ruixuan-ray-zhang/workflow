# AGENTS.md

## Repository role

This repository defines a public, portable meta-workflow seed. It distills reusable task, status, evidence, gate, adoption, and enterprise-handoff semantics without containing organization-specific configuration.

Read before non-trivial work:

1. `docs/META_WORKFLOW.md`
2. `docs/ENTERPRISE_HANDOFF.md`
3. `docs/PROVIDER_ADAPTERS.md`
4. `docs/ADOPTION_GUIDE.md`
5. `docs/UPGRADE_GUIDE.md`
6. `docs/HUMAN_VALIDATION.md`
7. `docs/PROJECT_STATUS.md`
8. `docs/DECISIONS.md`
9. the current file in `docs/tasks/`

## Public boundary

Never add:

- organization names or identifiers;
- internal repository, tracker, registry, or service URLs;
- internal hostnames, IP addresses, network topology, or firewall rules;
- credentials, tokens, certificates, private keys, or secret names;
- proprietary source code, datasets, logs, metrics, model details, or customer information;
- private absolute paths or user-specific environment configuration.

Use logical roles and placeholders. Internal values are filled only after enterprise import.

## Authority rules

- This repository is authoritative only for the portable public contract.
- A completed enterprise handoff transfers organization-level authority to the internal workflow repository.
- A project-local Task MD is authoritative for one adopted project's task scope and execution contract.
- Provider trackers are mutable projections, never independent specification sources.
- Persistent artifacts are evidence of execution, not substitutes for the versioned task contract.
- Do not add automatic public-to-internal synchronization or reverse synchronization.

## Core integrity rules

- Do not silently change task goals, acceptance criteria, execution authorization, status semantics, or evidence requirements.
- Record consequential choices in `docs/DECISIONS.md`.
- Separate implementation, execution, artifact persistence, real-result availability, and human acceptance.
- Separate dry-runs from live execution.
- Do not convert unavailable or unassessed values to zero or success.
- Do not claim live success without persisted evidence.
- Reconcile local rules during adoption or upgrade; never overwrite them mechanically.

## Gate rules

- Create gates only at meaningful dependency, restart, environment, expensive-run, approval, or human-inspection boundaries.
- Dependencies come from explicit relations, never display order.
- Every gate has one or more observable exit checks.
- Machine gates require evidence before completion.
- Approval and human gates are never agent-completable.
- Failed or blocked predecessors stop the affected dependency path.
- Agents do not close a task parent or final delivery record when human acceptance is pending.

## Change workflow

For changes after the initial empty-repository bootstrap:

1. create or update a versioned Task MD;
2. create a short tracking issue when repository policy uses issues;
3. make the smallest scoped change;
4. validate references, placeholders, formatting, and public-boundary safety;
5. update `docs/PROJECT_STATUS.md`;
6. update `docs/DECISIONS.md`, `VERSION`, and `CHANGELOG.md` when semantics change;
7. open a reviewed pull request;
8. require human merge for contract changes.

## Roles

- Human owner: owns workflow direction, public-release decisions, enterprise-handoff authorization, and final merge.
- Planning agent: designs Task contracts, audits consistency, and interprets validated results.
- Implementation agent: implements scoped changes, runs permitted checks, and records evidence.
- Provider adapter: maps abstract roles to concrete repositories, trackers, CI systems, servers, and artifact stores.
- Internal maintainer: owns organization-specific evolution after handoff.

## Definition of done

A workflow change is done only when:

1. the requested contract is implemented without unrelated expansion;
2. public-boundary checks pass;
3. referenced files and examples are consistent;
4. status and decisions are accurate;
5. provider-neutral semantics remain clear;
6. no automatic sync or internal dependency was introduced;
7. human review has occurred when authority, status, gate, evidence, or acceptance semantics changed.
