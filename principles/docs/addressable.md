# DOC-ADDRESSABLE - Make every section directly linkable

**Layer:** 2 (contextual)
**Categories:** documentation, usability, information-architecture
**Applies-to:** docs
**Summary:** Give every meaningful document section a stable, direct link using consistent, non-duplicate headings.

## Principle

Every meaningful section of a document should be reachable by a stable, direct link. In practice this means: use headings consistently so that renderers generate anchor IDs, keep heading text stable once published so that anchors do not silently break, avoid duplicate headings within a file (which produce colliding or unpredictable anchors), and use explicit anchor syntax (`{#id}` in Pandoc Markdown, `[[id]]` in AsciiDoc) where stable IDs are required regardless of heading text changes.

A documentation page that cannot be linked to at the section level forces readers to share page-level links with instructions like `"scroll down to the third heading"` - a fragile and frustrating experience.

## Why it matters

Technical documentation is referenced constantly: in issue trackers, pull request comments, chat messages, error messages, and runbooks. When a referenced section has no stable anchor, links break silently as headings are renamed or reorganised. Readers arriving at a broken or page-level link must scan the entire document to find the relevant section. Addressability is the foundation of documentation as a reusable reference artefact.

## Violations to detect

- Duplicate heading text within the same file (produces colliding anchor IDs in most renderers: `#overview`, `#overview-1`, `#overview-2`)
- Headings that are too vague to produce useful anchors: `"Details"`, `"More"`, `"Notes"`, `"Other"` - readers cannot predict or remember the anchor
- A long document (more than one screen of content) with no headings, making no section linkable at all
- AsciiDoc or Pandoc Markdown files where sections intended as stable reference targets have no explicit anchor ID, relying solely on auto-generated heading slugs that will break if the heading is reworded
- Internal cross-references using bare `"see below"` or `"see above"` rather than a named section link

## Inspection

- `grep -rn "^#" $TARGET --include="*.md" --include="*.adoc" | sed 's/.*#\+ //' | sort | uniq -d` | MEDIUM | Duplicate heading text within files (colliding anchors)
- `grep -rn "see below\|see above\|refer to above\|refer to below" $TARGET --include="*.md" --include="*.adoc"` | LOW | Positional cross-references that should be named section links

## Good practice

- Use specific, descriptive heading text so the auto-generated anchor is human-readable and memorable
- Avoid reusing the same heading text in the same file; if two sections genuinely have the same name, disambiguate them
- For sections that are frequently linked to from external sources, add an explicit anchor ID so the link survives heading rewrites
- Replace `"see below"` / `"see above"` with a named link: `[Rate limiting configuration](#rate-limiting-configuration)`
- Treat anchor stability as part of the backwards-compatibility contract for published documentation: renaming a heading is a breaking change

## Sources

- "Docs Principles: Addressable." *Write the Docs*. https://www.writethedocs.org/guide/writing/docs-principles/ (accessed 2026-03-22).
- Baker, Mark. *Every Page is Page One: Topic-Based Writing for Technical Communication and the Web*. XML Press, 2013. ISBN 978-1937434281.
