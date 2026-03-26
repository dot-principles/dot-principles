# DOC-PURPOSE — Every document has one clear purpose

**Layer:** 1 (universal)
**Categories:** documentation, readability
**Applies-to:** docs
**Summary:** Assign each document exactly one purpose—tutorial, how-to, reference, or explanation—and never mix them.

## Principle

Every document should serve exactly one reader goal. The four fundamental documentation types — tutorials, how-to guides, reference material, and explanations — serve different purposes and should not be mixed. A document that tries to be a tutorial and a reference simultaneously fails at both: it neither guides a beginner through a task nor provides the exhaustive detail an experienced user needs.

Before writing, define the document's type and its single primary question: "How do I do X?", "What does Y mean?", or "Why was Z designed this way?" Every section should advance that one answer.

## Why it matters

Mixed-purpose documents disorient readers because each documentation type requires a different reading posture. A reader following tutorial steps does not want to be interrupted by reference tables. A reader scanning reference material does not want narrative prose. Documents that serve multiple purposes satisfy none well, grow without bound, and become hard to maintain.

## Violations to detect

- A README that contains step-by-step installation instructions, an API reference, a conceptual overview, and a changelog all in one file
- A tutorial that interrupts the step sequence with exhaustive option tables
- An architecture doc that doubles as an operations runbook
- A how-to guide that starts with long explanatory background before the first actionable step

## Good practice

- Choose one documentation type before you start writing: tutorial, how-to, reference, or explanation
- State the document's purpose in the first sentence or opening section
- Link to related documents of other types rather than embedding their content
- If a document is growing beyond its purpose, split it into purpose-specific files
- Use the Divio documentation system as a guide: each type has a distinct structure and tone

## Sources

- Procida, Daniele. "Diátaxis — A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-18).
- Procida, Daniele. "What nobody tells you about documentation." *PyCon Australia*, 2017. https://www.youtube.com/watch?v=azf6yzuJt54
