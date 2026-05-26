# ARCH-DECISION-RECORDS - Record architecture decisions as ADRs

**Layer:** 1 (universal)
**Categories:** architecture, governance, documentation
**Applies-to:** all
**Summary:** Capture every significant architectural decision as an ADR recording context, decision, and consequences.

## Principle

Every significant architectural decision - one that affects structure, non-functional characteristics, dependencies, interfaces, or construction techniques - must be captured as an Architecture Decision Record (ADR). An ADR records the context, the decision, and the consequences so that future contributors understand not just what was decided but why, and what was rejected.

## Why it matters

Without decision records, architectural rationale lives only in the memories of people who were in the room. New team members re-litigate settled decisions, incumbents defend choices they can no longer justify, and the system drifts away from its original intent invisibly. ADRs make the decision landscape explicit and auditable.

## Violations to detect

- Architecture choices that exist in code but not in any written record
- PRs that introduce structural changes (new service boundaries, framework adoption, protocol choices) with no accompanying ADR
- Teams that say "we decided not to use X" but cannot point to a document explaining why
- ADR files that exist but were never updated when the decision was reversed or superseded

## Good practice

- Store ADRs in the repository alongside the code they govern (`docs/decisions/` or `adr/`)
- Use **MADR** (Markdown Architectural Decision Records) as the recommended template - it is machine-parseable, Git-friendly, and widely tooled: https://adr.github.io/madr/
- Number ADRs sequentially and never delete them - supersede them with a new record
- Link ADRs from the relevant code, README, or DESIGN document so they are discoverable

## Sources

- Nygard, Michael. "Documenting Architecture Decisions." *Cognitect Blog*, 2011. https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- MADR - Markdown Architectural Decision Records: https://adr.github.io/madr/
- Richards, Mark and Ford, Neal. *Fundamentals of Software Architecture*. O'Reilly, 2020. ISBN 978-1-4920-4345-4. Chapter 19.
