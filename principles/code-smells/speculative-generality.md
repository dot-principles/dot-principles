# CODE-SMELLS-SPECULATIVE-GENERALITY — Speculative Generality

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Build only for today's known requirements; remove unused abstractions and speculative dead flexibility.

## Principle

Speculative Generality arises when developers build abstractions, hooks, or special cases to handle future requirements that may never materialise. Abstract classes with only one subclass, parameters that are never used, methods that exist "just in case" — all add complexity without current value. Build for today's known requirements and refactor when real needs emerge.

## Why it matters

Unused abstractions increase the surface area of the code that must be read, tested, and maintained. They obscure the design's actual intent and make it harder for newcomers to distinguish between what the system does and what someone imagined it might do someday. In practice, predicted futures rarely match reality.

## Violations to detect

- Abstract classes or interfaces with only a single implementation
- Parameters, fields, or methods that are never referenced outside of tests
- Hook methods or extension points that have never been extended
- Overly generic type parameters or configuration options with only one possible value in the codebase

## Good practice

- Remove unused abstractions: Collapse Hierarchy, Inline Function, Inline Class
- Follow YAGNI (You Aren't Gonna Need It): add complexity only when a concrete requirement demands it
- If a framework or library demands an extension point, that is not speculative — it is required by the architecture
- When you do foresee a need, add a TODO or note rather than building the abstraction now

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
