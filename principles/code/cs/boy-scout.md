# CODE-CS-BOY-SCOUT — The Boy Scout Rule

**Layer:** 1 (universal)
**Categories:** maintainability, refactoring, craftsmanship
**Applies-to:** all
**Summary:** Always leave the code cleaner than you found it by making small improvements on every touch.
**Audit-scope:** limited — git diff context (`$GIT_DIFF`) is loaded in Phase 1.4 and used for detection; new smells introduced in changed lines are detectable; whether the contributor made every possible improvement is a subjective judgment that cannot be automated

## Principle

Always leave the code cleaner than you found it. When you touch a file to add a feature or fix a bug, make a small improvement to the surrounding code — rename a confusing variable, extract a long inline expression, delete a stale comment, remove a dead branch. These micro-improvements compound over time and counteract the entropy that accumulates in any active codebase.

## Why it matters

Code quality degrades incrementally through hundreds of small compromises. No single change makes the codebase unmaintainable; the accumulation does. The inverse is also true: sustained small improvements prevent rot. The Boy Scout Rule distributes the refactoring burden across every change, eliminating the need for dedicated "clean-up sprints" that rarely get scheduled and are always deprioritised.

## Violations to detect

- Passing a confusing name, magic number, or stale TODO without touching it when you were already editing the file
- Adding new code to a function that is already too long without extracting it
- Committing changes that leave the file in visibly worse shape than before the edit
- "I'll clean it up later" left unrecorded with no follow-through

## Good practice

- Scope improvements to the code you are already touching — do not refactor an entire module as a side effect of a one-line bug fix
- Keep Boy Scout changes in the same commit as the feature or fix when trivial; use a separate commit when the improvement is larger, to keep diffs reviewable
- Treat the rule as a minimum, not a maximum — it does not prohibit larger refactors, it just ensures every change contributes something positive
- Apply the rule to tests and documentation, not just production code

## Sources

- Martin, Robert C. *Clean Code*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 1.
- Baden-Powell, Robert. Scout Movement founding principle (original metaphor).
