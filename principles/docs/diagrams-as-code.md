# DOC-DIAGRAMS-AS-CODE — Diagrams as Code

**Layer:** 1
**Categories**: documentation, tooling, format
**Applies-to**: all
**Summary:** Store diagrams as plain-text source files and render them at build or view time.

## Principle

Represent every diagram — architecture, sequence, data flow, entity-relationship — as a text file using a tool such as Mermaid, PlantUML, Graphviz DOT, or C4-DSL. Render images at build or view time. Binary diagram files (`.vsdx`, `.drawio`, hand-edited `.svg`) must not be the source of truth.

## Why it matters

Binary diagrams can't be diffed, reviewed in a pull request, or edited without a proprietary GUI. Text-source diagrams version like code: every change is auditable, merge conflicts are resolvable, and AI tools can read and generate them directly. Diagrams kept as plain text stay in sync with the codebase they document.

## Violations to detect

- `.vsdx`, `.drawio` (binary XML), or `.pptx` slides used as the canonical diagram source
- `.png` or `.jpg` diagram files committed with no corresponding plain-text source
- Hand-edited `.svg` with no source (treat generated SVG as output, not source)
- Diagram tools that export only binary formats used as the primary authoring tool

## Good practice

```
architecture.mmd      Mermaid — renders natively in GitHub, VS Code, Copilot
system-context.dsl    C4-DSL / Structurizr
dataflow.puml         PlantUML
pipeline.dot          Graphviz DOT
```

Commit the source file. Let CI or the viewer render the image. If a pre-rendered image is needed (e.g. for offline docs), commit it alongside the source and mark it generated.

## Sources

- [Mermaid](https://mermaid.js.org/) — diagrams in Markdown, rendered natively on GitHub
- [PlantUML](https://plantuml.com/) — broad UML and non-UML diagram support
- [Structurizr DSL](https://structurizr.com/dsl) — C4 model as code
- [Graphviz DOT](https://graphviz.org/) — general-purpose graph description language
