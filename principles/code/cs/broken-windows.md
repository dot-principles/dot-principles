# CODE-CS-BROKEN-WINDOWS — Broken Windows

**Layer:** 1 (universal)
**Categories:** maintainability, craftsmanship, team-culture
**Applies-to:** all
**Summary:** Fix quality lapses immediately; never let visible disorder signal that standards have dropped.

## Principle

One visible quality lapse signals that standards have dropped, inviting further neglect. A single broken window — an ignored test failure, a persistent TODO, a known bug left open, a function that everyone knows is wrong but nobody fixes — communicates that the codebase is not cared for. That signal lowers the bar for the next developer, who adds their own compromise, and entropy accelerates.

Fix broken windows as soon as they appear, or board them up explicitly (document, track, accept) if they cannot be fixed immediately.

## Why it matters

Codebase quality is partly a social phenomenon. When a team sees that others have left messes, the implicit standard shifts — the mess becomes the norm. Conversely, a consistently clean codebase creates social pressure to maintain it. The first broken window is disproportionately damaging: it breaks the signal that quality is cared about.

## Violations to detect

- Failing or skipped tests left in the suite with no tracking issue
- TODO/FIXME comments with no owner, no date, and no associated ticket
- Known bugs in the backlog that are never prioritised because the code "mostly works"
- Linting errors or compiler warnings suppressed globally rather than fixed
- Dead code, commented-out blocks, or stale feature flags left indefinitely

## Good practice

- Fix small breakages immediately — the cost is lowest at discovery
- If a fix requires more time than is available, board up the window explicitly: create a tracked issue, add a comment with a link, set an owner
- Treat the first suppressed warning or skipped test as a policy decision, not a one-off exception
- In code review, flag broken windows — not to block the change, but to ensure they are tracked

## Sources

- Wilson, James Q.; Kelling, George L. "Broken Windows." *The Atlantic*, March 1982. (original criminology theory)
- Hunt, Andrew; Thomas, David. *The Pragmatic Programmer*, 20th Anniversary ed. Addison-Wesley, 2019. ISBN 978-0-13-595705-9. Chapter 1: "Software Entropy."
