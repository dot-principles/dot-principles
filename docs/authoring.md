# Docs Authoring Guide

Use this guide when writing or revising the public docs in `content/`, the GitHub landing page in `README.md`, or architecture notes in `docs/`.

## Audience

Write for experienced developers who already use AI coding assistants and want better engineering judgment, not more hype.

- Assume the reader knows what a PR, CI run, linter, and architecture doc are.
- Do not explain obvious engineering basics.
- Do not write as if the reader needs to be convinced that AI exists.

## Tone

- Be direct, practical, and specific.
- Sound like an engineer explaining a useful pattern, not like marketing copy.
- Name tradeoffs in the same section as the recommendation.
- Keep claims honest: this project is useful, early, and still evolving.

Avoid generic AI language such as `transformative`, `cutting-edge`, `seamless`, or `unlock`.

## Structure for public docs pages

When possible, use this pattern:

1. **Problem**: what breaks or stays clumsy without the practice
2. **Practice**: what to do
3. **Evidence**: concrete repo behavior, command flow, or canonical reference
4. **Honest caveats**: limits, maturity, or tradeoffs
5. **Deep reference**: where the canonical detail lives

Put the constraint or non-goal early. Do not bury it in the conclusion.

## Credibility rules

- Treat repo conventions as repo conventions, not field standards.
- Time-bound current-practice claims about AI tooling and workflow maturity.
- Prefer wording like `can`, `often`, `in current practice`, or `this project` when the evidence is not universal.
- If a section is synthesis, label it as synthesis in the prose instead of implying broad consensus.
- When a stronger claim would need stronger evidence, weaken the claim instead.

Before considering a public docs page complete, run this mental credibility pass:

- `Missing local source`: are factual or operational claims unsupported?
- `Weak provenance`: is the claim stronger than the source behind it?
- `Overstated claim`: does the wording outrun the evidence?
- `Unlabeled synthesis`: is a project framing presented as field consensus?
- `Perishable claim`: does a time-sensitive statement need dating or scoping?
- `Field-consensus overreach`: does the page imply industry agreement where there is only current practice or opinion?

## Formatting

- Use prose paragraphs for explanation and fenced code blocks for commands.
- Use Mermaid for diagrams when a diagram materially helps the reader.
- Prefer tables for comparisons and reader pathways.
- Keep headings shallow and scannable.
- Use inline code for file names, paths, command names, directories, and flags.

## Source-of-truth boundaries

- `content/`: public docs pages and visitor journey
- `README.md`: concise GitHub entry point
- `INSTALL.md`: canonical install and platform detail
- `DESIGN.md`: canonical architecture and contributor detail
- `demo/presentation.md`: canonical workflow walkthrough
- `docs/`: docs-about-docs guidance and decisions