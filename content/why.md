# Why `.principles`

The strongest AI coding agents already know a huge amount of software engineering theory.

That is not the real problem.

The real problem is that generic knowledge is not the same as local judgment. The model may know SOLID, OWASP, DDD, fail-fast design, immutability, infrastructure-as-code, or documentation quality principles. But when it opens *your* file, it does not automatically know which of those matter here, in this repo, in this directory, for this kind of artifact.

Without that context, the agent falls back to reasonable defaults. Reasonable defaults are useful. They are not your architecture.

## The gap `.principles` fills

Specs answer **what the software should do**.

Tests answer **whether it does it**.

`.principles` answers **whether it is well-shaped** according to the standards your team actually wants applied.

That matters because a change can be correct and still be clumsy:

- a handler that contains business logic
- a function that has three reasons to change
- a retry path that is not idempotent
- an architecture document that buries the key decision
- a GitHub Actions workflow with broader permissions than it needs

These are the kinds of problems experienced reviewers catch from judgment rather than from syntax rules. `.principles` turns that judgment into version-controlled plain text an agent can apply consistently.

## What this project is

`.principles` is a principle-as-code framework.

- Principles live as Markdown files in a catalog.
- Projects activate them with `.principles` files in the repo tree.
- `dot-scout` helps place those files.
- `dot-prime` loads the most relevant rules before coding.
- `dot-audit` reviews the result against the active set.

The project is open, practical, and deliberately modest in its claims. It does not pretend to solve software quality on its own. It gives teams a better way to express engineering intent to AI tools they are already using.

## Why now

Teams are already using agents to write, review, refactor, and explain code. The open question is no longer whether the agent can produce output. The open question is whether the output reflects the standards the team cares about.

That is why this project exists.

It gives the agent a local, inspectable answer to:

- What principles matter in this codebase?
- Which ones matter in this subtree?
- Which ones matter for docs, infra, config, schemas, or pipelines?
- Which risks deserve extra scrutiny here?

## Honest caveats

This project is still early.

- The catalog is opinionated, not exhaustive.
- Teams will need to adapt or extend it for their own domain.
- Audit quality still depends on the model you use.

That is a reason to adopt it thoughtfully, not a reason to ignore the problem it addresses.

If your team keeps seeing the same quality issues in agent output, `.principles` gives you a place to encode those expectations where both people and tools can read them.