# PTAC-PLAIN-TEXT-FIRST — Plain Text First

**Layer:** 1
**Categories**: format, tooling, portability
**Applies-to**: all
**Summary:** Prefer plain text formats over binary; keep every artifact diffable and human-readable.

## Principle

Choose plain text representations for all artifacts that humans or tools need to read, review, or modify. Binary formats should be the exception, not the default — use them only when plain text is technically infeasible.

## Why it matters

Binary formats create friction: they can't be diffed, reviewed in a pull request, searched with grep, or read without a proprietary tool. Plain text artifacts can be version-controlled, merged, audited, and processed by AI tools without conversion. Binary blobs silently accumulate in repos, inflating size and eroding transparency.

## Violations to detect

- Committing `.docx`, `.xlsx`, `.pdf`, or other binary office formats as the source of truth
- Using binary serialization formats (e.g., Java `.ser`, Python `.pkl`) for configuration or data files that change over time
- Storing images, videos, or audio in a repo where plain-text alternatives (SVG, Mermaid diagrams, ASCII art) would suffice
- Build artifacts, compiled outputs, or generated binaries committed alongside source

## Good practice

```
# Prefer                       # Avoid
openapi.yaml                   openapi.json.gz
architecture.mermaid           architecture.vsdx
README.md                      README.docx
docker-compose.yml             docker-compose.bin
```

## Sources

- [Plain-Text-as-Code](https://github.com/Plain-Text-as-Code) — philosophy and examples
- Eric Raymond, *The Art of Unix Programming*, Chapter 5: "Textuality", Addison-Wesley, 2003.
