# Getting Started

You can get from curious to first use in one short path:

1. Install the commands into a target project.
2. Vendor the catalog so the project has the principle data locally.
3. Run `dot-scout` to create or refresh `.principles` files.
4. Run `dot-prime` before a coding session.
5. Run `dot-audit` after the change.

## 1. Install into a project

From this repository:

```bash
./install.sh all <project-dir>
```

That installs the command files for the supported agent environments and vendors the required catalog data into the target repo.

If you are on Windows, or if you want a narrower install target such as Copilot-only or Codex-only, use the full guide:

- [`INSTALL.md`](https://github.com/dot-principles/dot-principles/blob/main/INSTALL.md)

## 2. Commit the installed files

The commands are repo-local. Commit them so every teammate and every CI environment gets the same setup.

```bash
cd <project-dir>
git add .claude/ .github/ .agents/ .principles-catalog/
git commit -m "Add .principles AI commands and principle files"
```

## 3. Run `dot-scout`

Use the agent-native command for your environment:

```text
/dot-scout   # Claude / Copilot
$dot-scout   # Codex
```

`dot-scout` analyzes the project tree, detects stacks and signals, proposes `.principles` placement, and writes the files after confirmation.

## 4. Run `dot-prime` before coding

```text
/dot-prime   # Claude / Copilot
$dot-prime   # Codex
```

This resolves the active hierarchy and distills it to a compact set of rules for the task at hand. The agent already knows many principles in the abstract; `dot-prime` makes the relevant ones active now.

## 5. Run `dot-audit` after the change

```text
/dot-audit current changes
```

Or describe the target more naturally:

```text
/dot-audit the payment module
/dot-audit README.md
/dot-audit @ddd src/orders
```

The workflow is intentionally simple:

```text
dot-scout → dot-prime → code → dot-audit
```

## Next steps

- Go to [How It Works](how-it-works.md) if you want the mental model.
- Go to [Commands](commands.md) if you want the operational details.
- Go to [Extending](extending.md) if you want to add your own catalog.