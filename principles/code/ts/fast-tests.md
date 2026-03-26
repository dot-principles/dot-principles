# CODE-TS-FAST-TESTS — Keep tests fast

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Keep tests fast enough to run after every small change without degrading the developer feedback loop.

## Principle

Tests must run fast enough that developers execute them frequently — ideally after every small change. Slow tests break the feedback loop that makes TDD and continuous integration valuable. A test suite that takes too long to run will be skipped, run only in CI, or ignored entirely, undermining its purpose as a safety net.

## Why it matters

The value of a test suite is directly tied to how often it is run. Fast tests encourage developers to run them continuously, catching errors within seconds of introduction. Slow suites create pressure to batch changes, delay feedback, and ultimately lead to tests being abandoned or run only in overnight builds.

## Violations to detect

- Tests that perform real network I/O (HTTP calls, database queries to remote servers) when a local alternative exists
- Tests that use arbitrary `sleep` or `delay` calls to wait for asynchronous operations
- Tests that spin up heavy infrastructure (full application servers, Docker containers) for unit-level checks
- Test suites where individual tests take more than a second to execute
- Tests that read or write large files to disk unnecessarily

## Good practice

- Use in-memory implementations, fakes, or test doubles for external dependencies at the unit level
- Reserve real I/O and infrastructure for integration and end-to-end tests, which run less frequently
- Profile the test suite periodically and address tests that have become slow
- Separate fast unit tests from slower integration tests so the fast suite can run on every save
- Avoid unnecessary setup — create only the state each test actually needs

## Sources

- Martin, Robert C. *Clean Code: A Handbook of Agile Software Craftsmanship*. Prentice Hall, 2008. ISBN 978-0-13-235088-4. Chapter 9: "Clean Tests — F.I.R.S.T."
