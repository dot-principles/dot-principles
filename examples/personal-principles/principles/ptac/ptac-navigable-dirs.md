# PTAC-NAVIGABLE-DIRS — Navigable Plain-Text Directories

**Layer:** 2
**Categories**: structure, navigation, discoverability
**Applies-to**: plain-text directories
**Summary:** Every plain-text directory must contain an INDEX.md listing its contents and a README.md describing its purpose.

## Principle

Every plain-text directory must contain two files with distinct roles:

- **`INDEX.md`** — machine-scannable table of every entry with a one-line description; for AI tools and automation that need to know what exists without reading every file.
- **`README.md`** — human-oriented description of the directory's purpose, scope, and how to use it; auto-rendered on GitHub, GitLab, and Bitbucket.

A README explains *what this is*; an INDEX says *what's in here*. They are not interchangeable.

## Why it matters

Without navigation aids, AI tools must speculatively read every file to understand the structure, wasting context. Human reviewers can't orient themselves quickly. New contributors don't know where to start.

## Violations to detect

- A plain-text directory with no `README.md` (invisible on GitHub, no human entry point)
- A plain-text directory with no `INDEX.md` (AI must guess the structure from filenames alone)
- A `README.md` that also tries to be an index (too long, two concerns mixed)
- An `INDEX.md` that explains purpose instead of listing content
- Subdirectories added without updating the parent's `INDEX.md`

## Good practice

`README.md` — describes purpose, scope, and how to use the content.
`INDEX.md` — a table listing every entry with a one-line description:

```markdown
# Index

| Path | Description |
|------|-------------|
| `adr/` | Architectural Decision Records (ADRs 001–020) |
| `c4-views/` | C4 context, container, and component diagrams |
| `glossary.md` | Domain terminology and abbreviations |
```

Keep them separate — a file that tries to be both becomes too long for either purpose.

## Sources

- [Plain-Text-as-Code](https://github.com/Plain-Text-as-Code) — philosophy and examples
- GitHub documentation: [About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
