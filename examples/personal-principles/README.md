# example-catalog

An example extra-catalog for the [`.principles`](https://github.com/dot-principles/dot-principles) system, demonstrating how to extend the built-in catalog with your own principles — without forking.

This catalog contains the **Plain-Text-as-Code (`ptac`) namespace** as a concrete, real-world example. Fork or clone it as a starting point for your own corporate or personal catalog.

Used with `install.sh` via [`--extra-catalog`](https://github.com/dot-principles/dot-principles/blob/main/INSTALL.md#9-corporate--personal-principles) — no fork needed.

---

## What's in here

The `ptac/` namespace captures principles from the Plain-Text-as-Code philosophy: treat every artifact as plain text in version control, composable, diffable, and natively readable by both humans and AI tools.

| ID | Summary |
|----|---------|
| `PTAC-PLAIN-TEXT-FIRST` | Prefer plain text formats over binary; keep everything diffable and human-readable. |
| `PTAC-COMPOSABLE-FILES` | Design files to be small, focused, and composable rather than large and monolithic. |
| `PTAC-NAVIGABLE-DIRS` | Every plain-text directory must contain an `INDEX.md` (AI navigation) and a `README.md` (human description, rendered on GitHub). |
| `PTAC-NO-GENERATED-BLOBS` | Avoid committing generated or binary blobs; commit source and generation instructions instead. |

---

## Quick start

### User-level setup (applies to all your projects)

```bash
# Clone this repo (or your fork)
git clone https://github.com/dot-principles/example-catalog ~/.my-extra-catalog

# Register it once
echo ~/.my-extra-catalog >> ~/.principles-extra
```

### Per-project setup

```bash
# Add to <project>/.principles-extra
echo /path/to/example-catalog >> my-project/.principles-extra
```

Then re-vendor your project:

```bash
cd /path/to/dot-principles
./install.sh vendor ~/projects/my-project
```

### One-off / CI

```bash
./install.sh vendor my-project --extra-catalog ~/my-extra-catalog
```

### Use the principles in a `.principles` file

```
# In any .principles file
PTAC-PLAIN-TEXT-FIRST
PTAC-COMPOSABLE-FILES
PTAC-NAVIGABLE-DIRS
PTAC-NO-GENERATED-BLOBS

# Or activate all PTAC principles as a group
@ptac
```

---

## Updating

```bash
cd ~/.my-extra-catalog
git pull
# Re-vendor any projects that use it
cd /path/to/dot-principles && ./install.sh vendor ~/projects/my-project
```

---

## Structure

```
example-catalog/
├── README.md
├── principles/
│   └── ptac/
│       ├── catalog.yaml
│       ├── .context-prime.md
│       ├── .context-audit.md
│       ├── .context-inspect.md
│       ├── ptac-plain-text-first.md
│       ├── ptac-composable-files.md
│       ├── ptac-navigable-dirs.md
│       └── ptac-no-generated-blobs.md
└── groups/
    └── ptac.yaml
```

---

## Creating your own catalog

Use this repo as a template:

1. Fork (or copy) it
2. Replace the `ptac/` namespace with your own
3. Follow the [extra-catalog template](https://github.com/dot-principles/dot-principles/tree/main/templates/extra-catalog) for structure conventions
4. Register it via `~/.principles-extra` or `--extra-catalog`

See [INSTALL.md §9 — Corporate & Personal Principles](https://github.com/dot-principles/dot-principles/blob/main/INSTALL.md#9-corporate--personal-principles) for the full guide.
