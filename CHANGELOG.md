# Changelog

Version numbers describe the public meta-workflow contract.

- **major**: incompatible authority, task, status, gate, evidence, or handoff semantics;
- **minor**: backward-compatible capabilities or required files;
- **patch**: compatible clarification and maintenance changes.

## 0.1.0 — Initial portable meta-workflow extraction

### Added

- A provider-neutral meta-workflow distilled from `research-agent-workflow-template` v0.3.0.
- A four-scope authority model: public seed, internal workflow repository, project instance, and numbered task.
- One-way enterprise handoff with `preserve_history` and `clean_snapshot` import modes.
- Explicit authority transfer, detached internal evolution, and no reverse-sync policy.
- Provider adapter roles for source control, tracking, review, build, test, artifact storage, and human authority.
- Independent implementation, execution, artifact, live-result, and human-validation states.
- Machine, approval, and human gate semantics with explicit dependencies and evidence.
- Enterprise import, internal profile, target-project audit, and project-adoption templates.
- A provider-neutral Task template and initial extraction record.
- Public-boundary rules preventing organization-specific information from entering this repository.

### Compatibility

- The original research workflow remains an upstream design source, not a runtime dependency.
- No GitHub, Linear, Azure DevOps, GitHub Enterprise, Jira, CI, or server integration is enabled by default.
- Internal repositories may customize or replace provider mappings after handoff.
