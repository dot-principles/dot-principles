# DOC-SELF-CONTAINED - Every page must make sense without requiring other pages to be read first

**Layer:** 2 (contextual)
**Categories:** documentation, usability, information-architecture
**Applies-to:** docs
**Summary:** Make every page intelligible in isolation by defining prerequisites and context without assuming prior reading.

## Principle

Every documentation page should be intelligible to a reader who arrives at it directly - via a search engine, a shared link, or an in-app help link - without having read any other page in the documentation. The page must establish its own context: define or link to any prerequisite concepts it relies on, state what the reader needs to know before proceeding, and not assume awareness of content established elsewhere in the same documentation set.

This is the "Every Page is Page One" principle: on the web, every page is potentially the first page a reader encounters.

## Why it matters

Documentation navigation assumptions were formed in the era of printed manuals read sequentially from page one. Web readers arrive from external search engines, deep links in Stack Overflow answers, and error message references. A page that opens mid-explanation - using undefined terms, referencing prior steps, or assuming a context established elsewhere - fails every reader who arrives without that context, which in practice is most readers.

## Violations to detect

- A page that uses an acronym or technical term on first use without defining it or linking to a definition
- A how-to guide whose first step assumes the reader has completed steps described on a different page, with no link to those steps
- A section that begins `"As described above…"` or `"As we saw in the previous section…"` and the reference is to a different document
- A page with no introductory sentence or paragraph establishing what it is about and who it is for
- Tutorial steps that reference a configuration set up in a previous tutorial without re-stating the prerequisite or linking to it

## Inspection

- `grep -rn "as described above\|as we saw\|as mentioned earlier\|in the previous section\|in the last section" $TARGET --include="*.md" --include="*.adoc" --include="*.rst"` | MEDIUM | Cross-references that assume sequential reading

## Good practice

- Open every page with one or two sentences that state the page's purpose and its intended reader
- Define or link every term that a reader arriving cold would not know; use a glossary for recurring terms
- If a page depends on prerequisites, state them explicitly at the top with links: `"Before you begin: complete X and Y"`
- Avoid `"as described above/earlier/previously"` for content that is on a different page; instead, link directly to the relevant section
- Test self-containedness by sharing the link with someone unfamiliar with the surrounding documentation and observing where they get stuck

## Sources

- Baker, Mark. *Every Page is Page One: Topic-Based Writing for Technical Communication and the Web*. XML Press, 2013. ISBN 978-1937434281. Chapter 4: "Every page is page one."
- Procida, Daniele. "Diátaxis - A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-22).
