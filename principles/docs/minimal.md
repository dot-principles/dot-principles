# DOC-MINIMAL — Write only what is necessary

**Layer:** 1 (universal)
**Categories:** documentation, simplicity
**Applies-to:** docs
**Summary:** Omit speculative, derivable, or duplicated content; every sentence must earn its place by serving the reader.

## Principle

Apply YAGNI to prose: do not document speculative features, rarely-used edge cases, behavior the reader can derive from context, or information that duplicates what is already covered elsewhere. Every sentence in a document has a maintenance cost. Sentences that do not serve the reader's goal are a net negative.

Minimal documentation is not sparse documentation. It is precise documentation: exactly what the reader needs to accomplish their goal, and nothing more.

## Why it matters

Over-documented systems create an illusion of completeness while hiding what matters under layers of noise. Readers learn to skim and miss critical information. Maintainers face an ever-growing surface area to keep accurate. The documentation that survives and stays trusted is the documentation that is small enough to keep current.

## Violations to detect

- README files that document every configuration option when a link to reference docs would suffice
- "Getting started" guides that begin with five paragraphs of history before the first actionable step
- Documentation that re-states what is obvious from the code, config, or type signature
- Hedge sentences like "this may or may not apply in your case" that add words without adding information
- Documenting internal implementation details that users do not need to use the system correctly
- Copy-pasted boilerplate sections that contain no content specific to this document

## Good practice

- Start with the minimum viable document: the one thing the reader must know to succeed
- Delete content that was true once but is no longer relevant, rather than leaving it "just in case"
- Prefer linking to authoritative sources over repeating their content
- Challenge every paragraph: what does the reader do differently after reading this?
- Apply the same code-review discipline to documentation PRs that you apply to code PRs

## Sources

- Procida, Daniele. "Diátaxis — A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-18).
- Beck, Kent. *Extreme Programming Explained: Embrace Change*. 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4. (YAGNI applied to documentation.)
