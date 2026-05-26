# DOC-AS-CODE - Treat documentation as source code

**Layer:** 1 (universal)
**Categories:** documentation, maintainability, process
**Applies-to:** docs
**Summary:** Store documentation in version control alongside code and apply the same review and CI workflow.
**Audit-scope:** limited - CI integration and external-wiki usage are not detectable from file contents; the presence of doc validation config and plain-text doc files is detectable

## Principle

Documentation should live in version control alongside the code it describes, be authored in a plain-text format (Markdown, AsciiDoc, reStructuredText), and follow the same contribution workflow as code: branches, pull requests, peer review, and automated validation in CI. A documentation change that accompanies a code change is part of the same commit or PR, not a separate ticket in a wiki.

Treating docs as code couples documentation updates to code changes structurally, making divergence visible in diffs and reviewable in the same tool developers already use.

## Why it matters

Documentation maintained outside version control - in wikis, shared drives, or standalone CMS systems - drifts from the code it describes because updates to docs and code are not coupled. There is no audit trail, no diff, and no review gate. Engineers most qualified to write accurate documentation are excluded from the editing workflow. Over time, unreviewed content accumulates and trust in the documentation collapses.

## Violations to detect

- A repository where documentation files are absent and a wiki URL is the only documentation reference in the README
- Documentation committed directly to the main branch with no pull request or review trail
- No automated validation (link checking, doc-tests, linting) configured for documentation in CI
- Binary or proprietary-format documentation files (`.docx`, `.pdf` source) committed to the repository
- A `CHANGELOG` or API documentation that is generated from a separate, unversioned source

## Inspection

- `find $TARGET -name "*.docx" -o -name "*.pages"` | MEDIUM | Binary doc formats committed instead of plain text
- `grep -rlE "wiki\.(github|confluence|notion)" $TARGET --include="*.md"` | INFO | External wiki links that may indicate docs live outside the repo

## Good practice

- Store all documentation in version control in the same repository as the code it describes
- Use plain-text formats (Markdown, AsciiDoc, reStructuredText) that are diffable and mergeable
- Require documentation updates in the pull request that changes user-facing behavior; make it part of the definition of done
- Run link checkers, spell checkers, and doc-tests in CI on every PR that touches documentation
- Review documentation with the same rigour as code - assign a reviewer, leave comments, and request changes

## Sources

- Gentle, Anne. *Docs Like Code*, 2nd ed. Just Write Click, 2019. ISBN 978-1365418730.
- Holscher, Eric. "Docs as Code." *Write the Docs*. https://www.writethedocs.org/guide/docs-as-code/ (accessed 2026-03-22).
