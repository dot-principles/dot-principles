# Commands

The project revolves around two commands. Together they create a complete quality loop for agent-assisted work.

## `dot-scout`

**Purpose:** analyze a repo and create or refresh `.principles` placement.

Use it when:

- you are adopting `.principles` in a project for the first time
- the stack has changed
- the generated instruction files need to be refreshed

What it does:

- scans the repo tree
- detects stacks, artifact types, and domain signals
- proposes `.principles` files at the right directory levels
- emits the generated instruction files agents use for fast resolution

## `dot-audit`

**Purpose:** review a target against the active principles after a change.

Use it when:

- you want a principle-oriented review of changed code
- you want findings grouped by severity
- you want the agent to fix and continue through an audit workflow

What it does:

- resolves the active rules
- loads the underlying principle content
- reviews the chosen scope
- reports findings such as critical, high, medium, and low severity issues

## Typical flow

```text
dot-scout   → set up the repo's principle map
dot-audit   → check whether the result reflects those rules
```

## Natural-language targeting

These are agent commands, not traditional CLI subcommands. You can usually describe the target naturally.

```text
/dot-audit current changes
/dot-audit the payment module
/dot-audit @ddd src/orders
```

## See the full walkthrough

For an end-to-end demonstration, see [Examples](examples.md) and the canonical demo file at [`demo/presentation.md`](https://github.com/dot-principles/dot-principles.github.io/blob/main/demo/presentation.md).
