# CODE-DX-DELETE-DEAD-CODE - Delete dead code

**Layer:** 1 (universal)
**Categories:** developer-experience, readability
**Applies-to:** all
**Summary:** Remove all code that is no longer executed or referenced; rely on version control for history.

## Principle

Remove code that is no longer executed or referenced. Dead code - unreachable branches, unused functions, commented-out blocks, obsolete feature flags - adds noise to the codebase without providing value. It misleads readers into thinking it is relevant, increases the surface area for bugs, and slows down comprehension. Version control preserves history; the codebase should reflect only what is currently needed.

## Why it matters

Dead code imposes a maintenance tax on every developer who encounters it. Readers waste time understanding code that does nothing. Refactorings become harder because developers are unsure whether the "dead" code is truly unused or merely called through a path they have not discovered. Removing dead code shrinks the codebase, clarifies intent, and reduces the risk of accidentally reactivating obsolete behavior.

## Violations to detect

- Commented-out blocks of code checked into the repository
- Functions, methods, or classes that are never called or instantiated
- Imports or `require` statements for modules that are no longer used
- Feature flag branches for flags that have been permanently resolved
- Variables that are assigned but never read
- Entire files that are not referenced from any entry point

## Inspection

- `grep -rnE '^\s*(//|#)\s*(function |def |class |public |private |protected )' $TARGET` | MEDIUM | Commented-out function/class definitions
- `grep -rnE 'TODO.*(remove|delete|clean ?up)|FIXME.*(remove|delete|dead)' -i $TARGET` | LOW | TODO markers for dead code removal

## Good practice

- Delete dead code immediately when you identify it - do not leave it "just in case"
- Trust version control to preserve historical code; do not use comments as a backup mechanism
- Use static analysis tools and IDE features to detect unused code automatically
- Clean up feature flags and their associated code paths as part of the flag retirement process
- When removing dead code, run the full test suite to confirm nothing depended on it unexpectedly

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*. 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Code smell: "Dead Code."
