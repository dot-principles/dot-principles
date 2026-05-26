# CODE-SMELLS-COMMENTS-AS-DEODORANT - Comments as Deodorant

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Refactor code to make intent self-evident; use comments only to explain why, never what.

## Principle

A comment that explains what a block of code does is often a sign that the code should be refactored to make its intent obvious without the comment. When you feel the need to write a comment, first try to restructure or rename so the comment becomes superfluous. Good comments explain *why* something is done, not *what* is being done - the code itself should communicate the what.

## Why it matters

Comments that paraphrase code add maintenance burden: when the code changes, the comment must change too, and it rarely does. Over time, misleading comments become worse than no comments at all. If the code cannot stand on its own, improving its clarity is more valuable than annotating its obscurity.

## Violations to detect

- Block comments that summarise the next few lines of code (a sign to Extract Function with a descriptive name)
- Comments that explain what a variable holds (rename the variable instead)
- Commented-out code left "just in case" - version control serves this purpose
- Long header comments restating what is already clear from the method signature and name

## Good practice

- Extract Function and give it a name that says what the comment would have said
- Rename variables and methods to eliminate the need for explanatory comments
- Reserve comments for *why* decisions: trade-offs, workarounds, regulatory reasons, or non-obvious algorithmic choices
- Delete commented-out code - trust version control to preserve history

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
