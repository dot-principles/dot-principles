# DOC-UNIQUE - Each piece of information has exactly one home

**Layer:** 1 (universal)
**Categories:** documentation, maintainability, consistency
**Applies-to:** docs
**Summary:** Maintain a single canonical source for every piece of content and link to it rather than duplicating.

## Principle

Every piece of documentation content should exist in exactly one canonical location. Other documents that need that information should link to the canonical source, not copy its text. When the same content lives in multiple places, each copy becomes an independent maintenance obligation; they will diverge as the product evolves, and readers will encounter conflicting versions with no way to know which is correct.

This is the documentation equivalent of the Single Source of Truth principle: one authoritative location per fact, concept, or procedure.

## Why it matters

Duplicated documentation creates silent inconsistency. When a procedure changes, the author updates the page they are thinking about and forgets the copies. Readers following an outdated copy encounter errors, waste time debugging, and lose trust in the documentation. The problem compounds invisibly: there is no compile error for a stale copy.

## Violations to detect

- Installation instructions repeated verbatim in a `README.md`, a `CONTRIBUTING.md`, and a `docs/getting-started.md` with no cross-links
- A configuration reference whose parameter descriptions appear both in the API docs and in a separate guide, with no indication which is authoritative
- A changelog or version history maintained in both a `CHANGELOG.md` and a wiki page
- Conceptual background sections copy-pasted across multiple how-to guides rather than extracted into a shared explanation document
- Two documents that describe the same workflow in different words, creating ambiguity about which is current

## Inspection

- `grep -rl "Installation\|Prerequisites\|Getting Started" $TARGET --include="*.md" | wc -l` | INFO | Count of files with common duplicated section headings - high counts warrant review

## Good practice

- Identify the single correct home for each piece of information; every other document that needs it links there instead of copying it
- Treat a duplicated section as a refactoring target: extract the content to its canonical location, replace copies with links, and note in a comment or link that the canonical source is elsewhere
- Use include directives (where the doc toolchain supports them) to transclude canonical content rather than copy it
- During PR review, search for content already documented elsewhere before approving additions

## Sources

- "Docs Principles: Unique." *Write the Docs*. https://www.writethedocs.org/guide/writing/docs-principles/ (accessed 2026-03-22).
- Procida, Daniele. "Each piece belongs in one correct place." In "Twelve principles of documentation." https://vurt.org/articles/principles-documentation/ (accessed 2026-03-22).
- Gentle, Anne. *Docs Like Code*, 2nd ed. Just Write Click, 2019. ISBN 978-1365418730.
