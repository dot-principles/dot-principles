# PTAC-DIAGRAMS-AS-CODE — Diagrams as Code

**Layer:** 1
**Categories**: format, tooling, diagrams
**Applies-to**: all
**Summary:** Represent diagrams as plain-text source files; generate images at build time, not by hand.

## Principle

Store diagrams as text — Mermaid, PlantUML, Graphviz DOT, C4-DSL, or similar — and render them at build or view time. Binary diagram files (`.vsdx`, `.drawio`, `.png`, `.svg` of unknown origin) should not be the source of truth.

## Why it matters

Binary diagram files can't be diffed, reviewed in a pull request, or edited without a proprietary GUI tool. Text-source diagrams version like code: every change is auditable, merge conflicts are resolvable, and AI tools can read and generate them directly. Diagrams kept as plain text stay in sync with the codebase they document.

## Violations to detect

- Committing `.vsdx`, `.drawio` (binary XML), or `.pptx` slides as the canonical diagram source
- Committing `.png` or `.jpg` diagrams with no corresponding plain-text source file
- Hand-edited `.svg` files with no source (treat generated SVG as output, not source)
- Diagram tools that export only binary formats used as the primary authoring tool

## Good practice

```
architecture.mmd          (Mermaid — renders in GitHub, VS Code, Copilot)
system-context.dsl        (C4-DSL / Structurizr)
dataflow.puml             (PlantUML)
pipeline.dot              (Graphviz DOT)
```

Commit the source file. Let CI or the viewer render the image. If a pre-rendered image is needed (e.g., for offline docs), commit it alongside the source and mark it generated.

## Sources

- [Mermaid](https://mermaid.js.org/) — diagrams in Markdown, rendered natively on GitHub
- [PlantUML](https://plantuml.com/) — broad UML and non-UML diagram support
- [Structurizr DSL](https://structurizr.com/dsl) — C4 model as code
- [Graphviz DOT](https://graphviz.org/) — general-purpose graph description language
