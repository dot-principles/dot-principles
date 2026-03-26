# CODE-TS-TEST-INDEPENDENCE — Tests must be independent and isolated

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Each test must run in any order and in isolation, sharing no mutable state with other tests.

## Principle

Each test must be able to run in any order, in isolation or in parallel, and produce the same result. Tests must not share mutable state — no test should depend on the side effects of another test. Each test is responsible for setting up its own preconditions and cleaning up after itself.

## Why it matters

Coupled tests produce intermittent failures that depend on execution order, making them unreliable and expensive to debug. When tests share mutable state, a failure in one test can cascade into spurious failures in others, eroding confidence in the entire test suite.

## Violations to detect

- Shared mutable class-level or module-level variables modified across tests
- Tests that rely on execution order (e.g., test B assumes test A has already run)
- Database or file system state left behind by one test and assumed by another
- Static or global state mutation without reset between tests
- Tests that fail when run individually but pass when run in a specific order, or vice versa

## Good practice

- Use fresh fixtures for each test — create the state you need in setup, tear it down afterward
- Prefer in-memory or transactional test databases that roll back after each test
- Avoid class-level mutable state in test classes; use per-test instance variables
- Run tests in random order periodically to surface hidden coupling

## Sources

- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0.
