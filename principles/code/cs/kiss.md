# CODE-CS-KISS - KISS: Keep It Simple

**Layer:** 1 (universal)
**Categories:** simplicity, software-design, maintainability
**Applies-to:** all
**Summary:** Choose the simplest solution that correctly solves the problem; never add unnecessary complexity.

## Principle

Prefer the simplest solution that correctly solves the problem. Complexity is not a sign of sophistication - it is a liability. Every layer of abstraction, every configuration option, every generalisation added beyond immediate need makes the system harder to understand, test, debug, and change. Simple systems are more reliable, easier to onboard, and cheaper to maintain.

## Why it matters

Complexity compounds. A system that is hard to understand invites misuse, discourages refactoring, and slows incident response. Simple code can be reviewed quickly, reasoned about correctly, and changed safely. Most software that fails in production fails because of complexity - interactions no one fully understood - not because of missing features.

## Violations to detect

- Multiple layers of abstraction where one would suffice
- Configuration systems for options that never vary in practice
- Generic frameworks built for a single known use case
- Indirection (factories, registries, plugin systems) introduced before there is a second concrete use case
- Solutions that require a diagram to explain to a peer

## Good practice

- Start with the simplest thing that could possibly work; add complexity only when a concrete requirement demands it
- Measure complexity by the effort required for a new team member to understand and modify the code - not by line count
- Prefer explicit code over clever code: readable beats concise when they conflict
- Refactor toward simplicity when adding new behaviour - use each change as an opportunity to simplify, not complicate

## Sources

- Kelly Johnson, Lockheed Skunk Works, 1960s (original formulation in aerospace engineering).
- Martin, Robert C. *Clean Code*. Prentice Hall, 2008. ISBN 978-0-13-235088-4.
- Beck, Kent. *Extreme Programming Explained*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
