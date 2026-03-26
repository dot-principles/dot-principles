# CODE-TS-SINGLE-BEHAVIOR — Each test should verify one behavior

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Each test must assert exactly one logical behavior so failures pinpoint the broken condition immediately.

## Principle

A single test should assert one logical behavior or condition. When a test verifies multiple unrelated behaviors, a failure obscures which behavior is broken. One-behavior tests act as precise diagnostic instruments, pointing directly to the defect.

## Why it matters

Tests that verify multiple behaviors become fragile and hard to diagnose. When such a test fails, the developer must read the entire test to determine which behavior broke. Single-behavior tests produce failure messages that immediately communicate what went wrong, speeding up debugging and reducing the cost of change.

## Violations to detect

- Tests with many unrelated assertions checking different behaviors in sequence
- Test names that use "and" to describe what they verify (e.g., "validates input and saves record and sends notification")
- Tests that exercise multiple code paths or branches in a single method
- Setup blocks that configure scenarios unrelated to the assertion

## Good practice

- Write one test per distinct behavior, condition, or edge case
- Use descriptive test names that state the single expectation being verified
- If a test requires multiple assertions, ensure they all verify the same logical behavior from different angles
- Prefer more, smaller tests over fewer, larger ones

## Sources

- Beck, Kent. *Test Driven Development: By Example*. Addison-Wesley, 2002. ISBN 978-0-321-14653-3.
- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0.
