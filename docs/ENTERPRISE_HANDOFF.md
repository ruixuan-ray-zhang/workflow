# One-Way Enterprise Handoff

## Goal

Move a frozen public meta-workflow seed into an approved enterprise environment, transfer authority to an internal repository, and continue all organization-specific evolution internally.

```text
frozen public source
    -> isolated staging
    -> internal candidate
    -> security and completeness validation
    -> internal repository
    -> authority transfer and detach
```

This is a one-way handoff, not a long-lived fork synchronization contract.

## Preconditions

Before import, decide:

```text
Public source version:
Public source commit:
Import owner:
Internal repository destination:
Import method: preserve_history | clean_snapshot
Internal baseline version:
Security reviewer:
Handoff validator:
```

The source must be a frozen version or full commit, not an unrecorded moving branch.

## Import methods

### Preserve history

Clone the frozen public repository and push its history to the internal destination.

Use when:

- public commit history is permitted internally;
- decision provenance is useful;
- the organization accepts external author and URL metadata.

Required safeguards:

- remove or disable public push access;
- do not add internal commits to the staged public clone;
- record the source commit and import date;
- confirm the internal repository is the only writable authority.

### Clean snapshot

Export the frozen repository contents without `.git`, initialize a new internal repository, and create an internal baseline commit.

Use when:

- external history or remotes should not persist;
- a clean internal root is required;
- the organization prefers explicit provenance in a manifest.

Required safeguards:

- preserve source version and commit in `ENTERPRISE_IMPORT_MANIFEST.yml`;
- validate the exported file inventory;
- create the first internal commit only after internal customization is separated from the public staging copy.

## Handoff procedure

### H00 — Freeze and verify source

Record:

- repository;
- public version;
- full commit SHA;
- export timestamp;
- file inventory or archive checksum when used.

Stop if the source identity is ambiguous.

### H10 — Create isolated staging

Place the public source in an approved staging directory.

Rules:

- treat it as read-only input;
- add no organization values;
- run no automatic network synchronization;
- do not reuse the staging directory as the internal working repository.

### H20 — Generate the internal candidate

Create a separate internal candidate and add:

- completed `INTERNAL_WORKFLOW_PROFILE.yml`;
- organization security and ownership rules;
- provider adapters;
- internal version and changelog;
- internal project-adoption templates;
- internal execution and artifact contracts.

Do not put credentials or raw secrets in the internal repository either.

### H30 — Record provenance and authority

Create `ENTERPRISE_IMPORT_MANIFEST.yml` from the template and set:

```text
public origin is historical provenance
internal repository is authoritative
automatic upstream synchronization is disabled
reverse synchronization is prohibited
```

Public and internal versions evolve independently after this point.

### H40 — Validate the candidate

Verify:

- required public files are present;
- organization customization exists only in the internal candidate;
- no unresolved required placeholders remain;
- no credentials or disallowed private material are committed;
- internal provider and permission assumptions are documented;
- the internal workflow works without runtime access to the public repository;
- the public remote cannot receive an accidental internal push;
- automatic upstream and reverse synchronization are absent.

### H50 — Publish internally

Create the organization-owned internal repository and push the reviewed candidate.

The initial internal change should report:

- public origin version and commit;
- import method;
- internal baseline version;
- validation performed;
- known deferred customization;
- authority-transfer decision.

### H60 — Human validation and detach

An authorized human confirms:

- provenance is correct;
- internal ownership is clear;
- the repository is usable inside the enterprise boundary;
- public and internal workspaces are separated;
- the public source is no longer required for daily operation;
- reverse synchronization is disabled.

Then declare the handoff complete.

## Import manifest

Use `docs/templates/ENTERPRISE_IMPORT_MANIFEST.yml`.

The manifest records provenance without granting the public repository ongoing authority.

Do not store:

- credentials;
- internal tokens;
- private network details;
- raw internal logs;
- proprietary project content.

## After handoff

The internal repository may:

- change provider mappings;
- add organization policy;
- define build and test environments;
- create project-adoption tooling;
- version and release internal workflow updates;
- reject or adapt future public ideas.

The internal repository is not required to follow future public releases.

## Reviewing a future public change

A future public change may be considered only through a scoped internal task:

```text
review public diff
    -> classify adopt / adapt / defer / reject
    -> implement internally
    -> internal review and merge
```

Never merge or rebase public history automatically into the internal repository.

## Failure conditions

Stop the handoff when:

- source version or commit is unknown;
- internal and public workspaces are mixed;
- reverse-push safety is unverified;
- required internal ownership is unresolved;
- organization-specific content appears in the public source;
- the internal candidate still requires live public access;
- credentials or prohibited material are present;
- authority after handoff is ambiguous.
