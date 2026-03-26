# DOC-CLOSE-TO-CODE — Keep documentation close to what it describes

**Layer:** 1 (universal)
**Categories:** documentation, maintainability, cohesion
**Applies-to:** docs
**Summary:** Store documentation in the same directory as the artifact it describes to prevent drift.

## Principle

Documentation should live as close as possible to the artifact it describes. A module's README belongs in the module's directory. An API's usage guide belongs in the API package. An architecture decision belongs in the repository that owns the architecture. Distance between a document and its subject is the primary driver of documentation drift — when they are in different places, updating one without the other requires deliberate effort that often does not happen.

Proximity is not merely physical: the closer documentation is to its subject in the repository tree, the more likely developers will encounter it, maintain it, and discover when it is stale.

## Why it matters

Documentation stored far from the code it describes — in a central `docs/` repository, a wiki, or a top-level folder far from the implementation — is updated infrequently because developers do not encounter it during normal development. A package renamed, moved, or deleted rarely triggers an update to a distant wiki page. The further away documentation lives, the faster it drifts.

## Violations to detect

- A monorepo where all documentation is centralized in a top-level `docs/` directory with no documentation co-located in individual module or service directories
- A library or package with no `README.md` at its own directory level
- API documentation stored in a separate repository from the API implementation
- A directory containing complex logic with no adjacent explanation — no `README.md`, no doc-comment, no `ARCHITECTURE.md`
- Documentation that refers to file paths or module names that no longer exist in the adjacent source tree

## Inspection

- `find $TARGET -mindepth 2 -maxdepth 2 -name "*.go" -o -name "*.py" -o -name "*.ts" | xargs -I{} dirname {} | sort -u | xargs -I{} sh -c 'test -f {}/"README.md" || echo "No README: {}"'` | LOW | Package directories without a README
- `grep -rnE "\.\./\.\./\.\./|/docs/[a-z]" $TARGET --include="*.md"` | LOW | Deep relative paths suggesting docs are far from their subject

## Good practice

- Place a `README.md` in every package, module, or service directory that explains its purpose, inputs, outputs, and key design decisions
- Co-locate API reference documentation with the API source; generate or derive it from the source rather than maintaining it separately
- When moving or renaming a module, update documentation in the same commit — treat doc updates as part of the refactor
- Prefer many small, targeted documents close to their subjects over a single large documentation site that must be kept in sync from a distance
- Use relative links between documentation files to make co-location explicit and broken links detectable in CI

## Sources

- Martraire, Cyrille. *Living Documentation: Continuous Knowledge Sharing by Design*. Addison-Wesley, 2019. ISBN 978-0134689326. Chapter 2.
- Gentle, Anne. *Docs Like Code*, 2nd ed. Just Write Click, 2019. ISBN 978-1365418730.
