# Extra Catalog Template

This directory is a **starter template** for your own corporate or personal principles catalog — to be used alongside `.principles` without forking the main repo.

Copy this directory, rename it, and add your own principles. Then point `install.sh` at it via `--extra-catalog` or a config file.

See [INSTALL.md](../../INSTALL.md) for full setup instructions.

---

## Directory structure

```
my-principles/
├── README.md
├── principles/
│   └── <namespace>/          ← one directory per namespace (your choice of name)
│       ├── catalog.yaml      ← required: namespace description
│       ├── .context-prime.md ← compiled guidance for /dot-prime  (recommended)
│       ├── .context-audit.md ← compiled violation patterns for /dot-audit  (recommended)
│       ├── .context-inspect.md ← optional: grep-based pre-scan patterns
│       └── <namespace>-<slug>.md  ← one file per principle
└── groups/
    └── <group-name>.yaml     ← optional: bundle principles under a @group alias
```

### ID derivation

Principle IDs are derived from the file path relative to `principles/`:

| File path | ID |
|---|---|
| `principles/acme/api-style.md` | `ACME-API-STYLE` |
| `principles/corp/sec/no-eval.md` | `CORP-SEC-NO-EVAL` |
| `principles/personal/my-rule.md` | `PERSONAL-MY-RULE` |

- Each **directory segment** → uppercased
- The **filename** → strip `<parent-dir>-` prefix if present, uppercase the rest

---

## Quickstart

1. **Copy this template:**
   ```bash
   cp -r /path/to/.principles/templates/extra-catalog ~/my-principles
   cd ~/my-principles
   ```

2. **Rename the namespace** from `example` to something unique (e.g., `acme`, `corp`, `personal`):
   ```bash
   mv principles/example principles/acme
   ```

3. **Edit `principles/acme/catalog.yaml`** — set your namespace description.

4. **Add principle files** — use `principles/example/example-principle.md` as a guide.

5. **Update the pre-compiled context files** — copy the relevant content from your principle files into `.context-prime.md` and `.context-audit.md` (see the examples in this template).

6. **Register your catalog with a project:**
   ```bash
   # One-time: add to ~/.principles-extra (user-level)
   echo ~/my-principles >> ~/.principles-extra

   # Or per-project: add to <project-dir>/.principles-extra
   echo /shared/acme-principles >> my-project/.principles-extra

   # Or on the CLI (ad-hoc)
   ./install.sh vendor my-project --extra-catalog ~/my-principles
   ```

7. **Re-vendor:**
   ```bash
   cd /path/to/.principles
   ./install.sh vendor ~/projects/my-project
   ```

---

## Versioning

An extra catalog is just a directory — version-control it as a git repo:

```bash
cd ~/my-principles
git init
git add .
git commit -m "Initial principles catalog"
```

For corporate use: host it in a shared repo (e.g., `github.com/acme/acme-principles`) and have each developer clone it to a known path. Point `.principles-extra` at that path.

For personal use: keep it in your home directory or dotfiles repo.

---

## Files in this template

| File | Purpose |
|------|---------|
| `principles/example/catalog.yaml` | Namespace description (required) |
| `principles/example/.context-prime.md` | Pre-compiled prime context (recommended) |
| `principles/example/.context-audit.md` | Pre-compiled audit context (recommended) |
| `principles/example/example-principle.md` | A complete example principle file |
| `groups/example-group.yaml` | An example group bundling principles |
