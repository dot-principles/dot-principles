# personal-principles (local example)

> **Canonical location**: [`github.com/dot-principles/example-catalog`](https://github.com/dot-principles/example-catalog)
>
> This directory is a local copy kept for offline testing. The repo above is the published version.

A personal principles catalog demonstrating the [`--extra-catalog`](https://github.com/dot-principles/dot-principles/blob/main/INSTALL.md#9-corporate--personal-principles) feature of the [`.principles`](https://github.com/dot-principles/dot-principles) system, using the **Plain-Text-as-Code** (`ptac`) namespace as a real-world example.

---

## What's in here

The `ptac/` namespace captures principles from the [Plain-Text-as-Code](https://github.com/Plain-Text-as-Code) philosophy: treat every artifact as plain text in version control, composable, diffable, and natively readable by both humans and AI tools.

| ID | Summary |
|----|---------|
| `PTAC-PLAIN-TEXT-FIRST` | Prefer plain text formats over binary; keep everything diffable and human-readable. |
| `PTAC-COMPOSABLE-FILES` | Design files to be small, focused, and composable rather than large and monolithic. |
| `PTAC-NO-GENERATED-BLOBS` | Avoid committing generated or binary blobs; commit source and generation instructions instead. |

---

## Setup

### Option 1: User-level (applies to all your projects)

```bash
# Clone from GitHub (or clone this local copy path)
git clone https://github.com/dot-principles/example-catalog ~/.personal-principles

# Register it once
echo ~/.personal-principles >> ~/.principles-extra
```

### Option 2: Per-project

```bash
# Add to <project>/.principles-extra
echo /path/to/personal-principles >> my-project/.principles-extra
```

Then re-vendor your project:

```bash
cd /path/to/dot-principles
./install.sh vendor ~/projects/my-project
```

### Use the principles in a `.principles` file

```
# In any .principles file
PTAC-PLAIN-TEXT-FIRST
PTAC-COMPOSABLE-FILES
PTAC-NO-GENERATED-BLOBS

# Or activate all PTAC principles as a group
@ptac
```

---

## Updating

```bash
cd ~/.personal-principles
git pull
# Re-vendor any projects that use it
cd /path/to/dot-principles && ./install.sh vendor ~/projects/my-project
```

---

## Structure

```
personal-principles/
├── README.md
├── principles/
│   └── ptac/
│       ├── catalog.yaml
│       ├── .context-prime.md
│       ├── .context-audit.md
│       ├── ptac-plain-text-first.md
│       ├── ptac-composable-files.md
│       └── ptac-no-generated-blobs.md
└── groups/
    └── ptac.yaml
```

---

## Contributing / customising

Fork this repo and add your own `ptac/` principles or additional namespaces. The structure follows the [extra-catalog template](https://github.com/dot-principles/dot-principles/tree/main/templates/extra-catalog).
