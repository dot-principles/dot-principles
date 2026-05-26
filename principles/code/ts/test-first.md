# CODE-TS-TEST-FIRST - Write the test before the code

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Write a failing test before any production code and follow the red-green-refactor cycle strictly.
**Audit-scope:** limited - can detect absence of corresponding tests; cannot determine whether tests were written before production code (requires git history)

## Principle

Write a failing test before writing any production code, then write just enough code to make the test pass, then refactor. This red-green-refactor cycle keeps increments small, provides immediate feedback, and ensures every line of production code exists because a test demanded it.

## Why it matters

TDD produces code that is testable by construction. By writing the test first, you clarify the desired behavior before committing to an implementation, reducing the chance of over-engineering or building the wrong thing. The short feedback loop catches mistakes within seconds rather than hours.

## Violations to detect

- Production code committed without corresponding tests
- Large batches of production code written before any tests exist
- Tests written after the fact that merely confirm existing implementation rather than specifying behavior
- Skipping the refactor step, leading to passing but poorly structured code

## Good practice

- Start each task by writing one small, specific failing test
- Write only enough production code to pass the current failing test - resist the urge to write ahead
- Refactor after each green phase, improving design while tests stay green
- Commit at each green-refactor boundary to preserve working states

## Sources

- Beck, Kent. *Test Driven Development: By Example*. Addison-Wesley, 2002. ISBN 978-0-321-14653-3.
