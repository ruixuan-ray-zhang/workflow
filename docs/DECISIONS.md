# Decisions Log

Record consequential workflow decisions.

## Decision template

```md
## YYYY-MM-DD: <Decision title>

Decision:
<What was decided.>

Context:
<Why it was needed.>

Alternatives considered:
- <A>
- <B>

Reason:
<Why this choice.>

Consequences:
- <Benefit>
- <Cost or follow-up>

Revisit when:
<Trigger, if any.>
```

## 2026-08-27: Distill a portable meta-workflow

Decision:

Create a new public repository containing provider-neutral workflow semantics distilled from `research-agent-workflow-template` v0.3.0 at commit `56319a04cd1c94e7a8732e111914271fac36b9be`.

Context:

The target use requires preparing generic workflow logic publicly, importing it from an approved company computer, publishing an internal version to an organization-owned Git host, and continuing all organization-specific maintenance inside the enterprise boundary.

Reason:

A separate public seed avoids contaminating the research-specific template with company migration concerns and provides a focused place to iterate the reusable meta structure.

Consequences:

- The original research template remains a design origin, not a runtime dependency.
- GitHub/Linear-specific implementation is replaced by provider roles.
- Public and internal workflow versions may diverge.

## 2026-08-27: Use one-way detached enterprise handoff

Decision:

Enterprise import transfers authority to the internal workflow repository. Automatic upstream synchronization and reverse synchronization are disabled.

Alternatives considered:

- Maintain a long-lived downstream fork.
- Use the public repository directly from internal projects.
- Run a synchronization service.

Reason:

A one-way handoff gives a clear security boundary, avoids accidental internal disclosure, and permits independent internal evolution.

Consequences:

- The import manifest preserves provenance.
- Future public changes are optional ideas reviewed through scoped internal tasks.
- Internal changes are not pushed back automatically.

## 2026-08-27: Keep provider mappings outside the core contract

Decision:

Define semantic roles for specification, delivery, execution tracking, change review, build, test, artifact storage, and human authority. Concrete products are adapters.

Reason:

The workflow must survive changes in repository hosts, trackers, CI systems, server topology, tool names, and authentication methods.

Consequences:

- Task semantics do not depend on a particular MCP or API.
- Internal adopters must validate adapter capabilities before enabling them.
- Manual bounded fallbacks remain valid when automation is unavailable.

## 2026-08-27: Preserve independent states and human acceptance

Decision:

Retain independent implementation, execution, artifact, live-result, and human-validation dimensions, along with machine, approval, and human gates.

Reason:

Code completion, real execution, persisted evidence, and human acceptance answer different questions.

Consequences:

- A merge cannot imply live success.
- A machine result cannot imply human acceptance.
- Dependent work stops when required validation is pending, failed, or blocked.
