# GRASP-HIGH-COHESION - High Cohesion

**Layer:** 1 (universal)
**Categories:** software-design, maintainability
**Applies-to:** all
**Summary:** Keep each class focused on a single, closely related set of responsibilities; reject unrelated additions.

## Principle

Assign responsibilities so that cohesion remains high. A class should have a small, focused set of closely related responsibilities. Everything in the class should be related to its central purpose.

## Why it matters

Low-cohesion classes - those that do many unrelated things - are hard to understand, hard to reuse, and fragile to change. They accumulate unrelated dependencies, grow without bound, and make testing difficult because every test must set up an ever-wider context.

## Violations to detect

- A class with many methods that span multiple unrelated concerns (a "God class")
- Methods in a class that use completely different sets of fields - a sign the class should be split
- A class that is frequently changed for multiple unrelated reasons
- Utility or "helper" classes that accumulate unrelated static methods over time
- A service class with methods that have nothing to do with each other

## Good practice

- Each class should be describable in one sentence focused on a single theme
- Methods within a class should mostly use the same fields - high method-field cohesion
- When a class grows large, look for responsibility clusters that can be extracted
- Prefer many small, focused classes over a few large, general-purpose ones

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
- Yourdon, Edward, and Larry L. Constantine. *Structured Design*. Prentice Hall, 1979. ISBN 978-0-13-854471-3.
