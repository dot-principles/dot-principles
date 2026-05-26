# Examples

The best way to understand `.principles` is to see the full loop in motion.

## The demo path

The canonical walkthrough lives in [`demo/presentation.md`](https://github.com/dot-principles/dot-principles/blob/main/demo/presentation.md).

It demonstrates the project on a real codebase and shows the flow end to end:

1. install the commands
2. run `dot-scout`
3. run `dot-audit` on a target
4. inspect the findings
5. fix, commit, push, and open a PR
6. run `dot-prime` before the next coding session

## What to look for in the walkthrough

- how `.principles` files are placed in different subtrees
- how the audit groups findings by severity
- how the workflow supports both setup-time and day-to-day use
- how the commands stay conversational instead of becoming a dense CLI surface

## Example questions to try in your own repo

- Can `dot-scout` separate docs, infra, and application code cleanly?
- Does `dot-prime` surface the few rules your team most wants active?
- Does `dot-audit` catch the kinds of issues your best reviewer would flag?

If the answer becomes yes often enough, the framework is earning its place.