# PTAC-NAVIGABLE-DIRS — Navigable Plain-Text Directories

**Layer:** 2
**Categories**: structure, navigation, discoverability
**Applies-to**: plain-text directories
**Summary:** Every plain-text directory must contain an INDEX.md listing its contents and a README.md describing its purpose.

## Principle

Every plain-text directory must contain two complementary files:

- **`INDEX.md`** — a structured, machine-scannable index listing every subdirectory and file in the directory, with a one-line description of each. This is the navigation aid for AI tools and automated pipelines that need to understand what's available without reading every file.
- **`README.md`** — a human-oriented description of the directory's purpose, scope, and how to use its content. This file is automatically rendered by GitHub, GitLab, Bitbucket, and other git-hosting platforms, making it the natural entry point for human readers.

Both files serve distinct roles and are not interchangeable. A README explains *what this is and why it exists*; an INDEX says *what's in here and where to find it*.

## Why it matters

Plain-text repositories grow into forests of files and subdirectories. Without navigation aids:

- AI tools must speculatively read every file to understand the structure, wasting context and producing hallucinations about what exists
- Human reviewers can't quickly orient themselves in an unfamiliar part of the repo
- Automated tools (CI, search indexers, link checkers) can't traverse the repo predictably
- New contributors don't know where to start

`INDEX.md` solves the AI/automation problem. `README.md` solves the human/GitHub problem. Together they make a directory fully navigable from both angles.

## Violations to detect

- A plain-text directory with no `README.md` (invisible on GitHub, no human entry point)
- A plain-text directory with no `INDEX.md` (AI must guess the structure from filenames alone)
- A `README.md` that also tries to be an index (too long, two concerns mixed)
- An `INDEX.md` that explains purpose instead of listing content
- Subdirectories added without updating the parent's `INDEX.md`

## Good practice

```
architecture/
├── README.md        ← "This directory contains architectural decision records,
│                       C4 diagrams, and design notes for the IIP Baldur system."
├── INDEX.md         ← Lists: adr/ (19 ADRs), c4-views/ (3 diagrams), requirements/, ...
├── adr/
│   ├── README.md    ← "ADRs record significant architectural decisions."
│   ├── INDEX.md     ← Lists all 001-... through 020-... files with one-line summaries
│   └── 001-adopt-ais-retrieve-share-tech-stack.md
└── c4-views/
    ├── README.md    ← "C4 model views: context, container, and component diagrams."
    ├── INDEX.md     ← Lists each .dsl / .svg / .md file with purpose
    └── system-context.dsl
```

**INDEX.md format** — keep it scannable for both humans and AI:

```markdown
# Index

| Path | Description |
|------|-------------|
| `adr/` | Architectural Decision Records (ADRs 001–020) |
| `c4-views/` | C4 context, container, and component diagrams |
| `requirements/` | Functional and non-functional requirements |
| `glossary.md` | Domain terminology and abbreviations |
| `dataflow-overview.md` | End-to-end data flow narrative |
```

## Sources

- [Plain-Text-as-Code](https://github.com/Plain-Text-as-Code) — philosophy and examples
- GitHub documentation: [About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
