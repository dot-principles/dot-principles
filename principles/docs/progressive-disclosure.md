# DOC-PROGRESSIVE-DISCLOSURE — Reveal complexity progressively

**Layer:** 2 (contextual)
**Categories:** documentation, readability, usability
**Applies-to:** docs
**Summary:** Lead with the simplest case and layer increasing complexity so readers can stop when they have enough.

## Principle

Present information in layers of increasing complexity: begin with the simplest case that covers the majority of readers, then progressively reveal advanced options, edge cases, and deeper explanations. Readers who need only the simple case should be able to stop early. Readers who need depth should be able to find it without wading through introductory material.

Progressive disclosure respects that readers arrive with different goals. A new user and an expert user reading the same document have different tolerance for detail. The document should serve both without forcing either to read material irrelevant to their goal.

## Why it matters

Front-loading complexity drives away readers who only need the simple case — often the majority. Hiding advanced detail at the end frustrates experts who need it quickly. Documents that respect disclosure levels have higher completion rates, lower support burden, and better reader satisfaction.

## Violations to detect

- A getting-started guide that begins with a complete configuration reference before showing a minimal working example
- A tutorial that explains all edge cases and failure modes before the reader has seen the happy path succeed
- An architecture document that starts with implementation details before establishing the high-level mental model
- Advanced options embedded in the same section as basic options without clear visual separation
- No "quick start" or "TL;DR" section for readers who need the 20% that covers 80% of cases

## Good practice

- Open with the simplest possible working version of the thing being documented
- Structure headings to signal depth: "Basic usage" → "Configuration" → "Advanced options" → "Troubleshooting"
- Use collapsible sections, callout boxes, or "see also" links to separate introductory from advanced content
- Put the most common use case first; treat edge cases as footnotes or separate sections
- Write a one-paragraph summary or TL;DR at the top of long documents
- Consider linking to a "next steps" or "deeper dive" document rather than expanding the current one

## Sources

- Procida, Daniele. "Diátaxis — A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-18).
- Nielsen, Jakob. "Progressive Disclosure." *Nielsen Norman Group*, 2006. https://www.nngroup.com/articles/progressive-disclosure/ (accessed 2026-03-18).
