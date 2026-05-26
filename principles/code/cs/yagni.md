# CODE-CS-YAGNI - YAGNI: You Aren't Gonna Need It

**Layer:** 2 (contextual)
**Categories:** software-design, simplicity, agile
**Applies-to:** all
**Summary:** Never add functionality until it is actually needed; implement only what current requirements demand.

## Principle

Do not add functionality until it is actually needed. Every feature costs time to build, test, document, and maintain - features built speculatively for hypothetical future requirements carry those costs without delivering value. Implement the simplest thing that works for the current need; extend when a real requirement arrives.

## Why it matters

Speculative features add complexity without delivering value. They inflate the codebase, slow future refactoring, and often encode the wrong abstraction - built before the actual use case is understood. The cost of removing unused code is always higher than never writing it. Premature generality is one of the most common sources of accidental complexity.

## Violations to detect

- Code or methods added "we might need this later"
- Configuration flags or feature switches with no current consumer
- Generalisations built before a second use case exists
- Abstractions created from a single use case
- Callback hooks, plugin systems, or extension points added speculatively
- Parameters or options that are accepted but ignored

## Good practice

- Implement the simplest solution that satisfies the current requirement
- Wait for a second real use case before extracting a shared abstraction
- Delete speculative code on sight - if it is not tested and not called, remove it
- Defer architectural decisions until the requirements that drive them are concrete

## Sources

- Beck, Kent. *Extreme Programming Explained*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
- Fowler, Martin. "Yagni." https://martinfowler.com/bliki/Yagni.html
