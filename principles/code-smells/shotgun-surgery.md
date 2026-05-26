# CODE-SMELLS-SHOTGUN-SURGERY - Shotgun Surgery

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Consolidate scattered logic so that a single concept change requires editing only one location.

## Principle

Shotgun Surgery occurs when a single logical change requires making many small edits to many different classes. Every time you make a change to one concept, you have to hunt through the codebase to find all the places it affects and edit each of them. The change is spread out rather than localised in one place.

## Why it matters

Scattered responsibility makes changes risky (easy to miss a location), time-consuming, and prone to inconsistency. If the same concept appears in many places, a mistake in one of those places creates a subtle bug.

## Violations to detect

- A change to a business rule requires editing five or more files
- The same hardcoded constant or logic appears in many unrelated classes
- A cross-cutting concern (logging format, error handling, date formatting) is implemented inline in many places rather than centralised

## Good practice

- Use Move Function and Move Field to pull scattered code together into one class
- Inline the scattered class if the spread was caused by over-decomposition
- Shotgun Surgery is the inverse of Divergent Change: where Divergent Change says "split", Shotgun Surgery says "consolidate"

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
