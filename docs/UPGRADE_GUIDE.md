# Upgrade Guide

## Public seed releases

For a public meta-workflow release:

1. keep changes provider-neutral and non-confidential;
2. use a scoped Task;
3. update affected contracts and templates;
4. record consequential decisions;
5. update `VERSION` and `CHANGELOG.md`;
6. validate public-boundary safety;
7. require human review for authority, state, gate, evidence, or acceptance changes;
8. tag or release only after merge when the repository adopts releases.

## Internal workflow evolution

After enterprise handoff, the internal repository owns its own versions and history.

Internal versions do not need to match public versions:

```yaml
origin:
  public_version: "0.1.0"
  public_commit: "<source SHA>"

internal:
  version: "1.0.0"
```

Future internal changes are designed, reviewed, and maintained inside the enterprise environment.

## No automatic synchronization

Do not configure:

- automatic public pulls;
- automatic merge or rebase from the public repository;
- reverse synchronization;
- a background bridge;
- public write credentials in the internal environment;
- internal credentials in the public environment.

The public origin is provenance, not an active upstream authority.

## Optional review of a future public release

When an internal maintainer chooses to review a public release:

1. create a scoped internal upgrade Task;
2. compare the current internal contract with the selected public version;
3. classify each change as `adopt`, `adapt`, `defer`, or `reject`;
4. preserve internal security, provider, branch, execution, artifact, and acceptance rules;
5. implement the selected ideas as internal changes;
6. validate them through an internal pull request;
7. update internal provenance notes without changing the original import identity.

Do not combine workflow upgrades with new project features or scientific experiments.

## Project upgrade

For an adopted project:

1. identify the internal workflow version or commit being considered;
2. audit current project-local rules;
3. compare only relevant files and semantics;
4. classify changes;
5. preserve project-specific constraints;
6. update adoption metadata and decisions;
7. validate provider and execution assumptions;
8. run the smallest relevant pilot or deterministic checks;
9. report remaining deferred work.

Do not retroactively mark historical tasks or human validation as passed without evidence.

## Upgrade report

Report:

- old and new internal workflow versions and commits;
- files and semantics compared;
- adopted, adapted, deferred, and rejected changes;
- project and organization rules preserved;
- provider capabilities validated;
- status and evidence migrations;
- historical-task policy;
- checks performed;
- blockers and next step.

## Incompatible changes

Use a major internal version when changing:

- authority after handoff;
- Task source-of-truth rules;
- task-level status meaning;
- gate eligibility or completion;
- evidence requirements;
- human-validation or closure policy;
- security-boundary assumptions.

A migration plan must accompany incompatible changes.
