# SIMPLE-DESIGN-PASSES-TESTS — Passes All Tests

**Layer:** 1 (universal)
**Categories:** software-design, testing, simplicity
**Applies-to:** all
**Summary:** All code must pass every test before any other design quality concern is addressed.

## Principle

The most important rule of simple design is that the code must pass all its tests. No amount of elegance or minimalism matters if the software does not do what it is supposed to do. Tests encode the system's requirements, and passing them proves the code fulfills its purpose. This rule takes highest priority among the four rules of simple design.

## Why it matters

Code that is clean but incorrect is worthless. Tests provide confidence that the system behaves as intended and that changes do not introduce regressions. Without passing tests, refactoring and simplification become dangerous because there is no safety net to verify that behavior is preserved.

## Violations to detect

- Code committed with failing or skipped tests
- Features added without corresponding test coverage
- Tests that are commented out or annotated to be ignored without a clear, tracked reason
- Test suites that are not run as part of the build or CI pipeline
- Tests that pass trivially (e.g., no assertions, always-true conditions)

## Good practice

- Write tests before or alongside production code to ensure every behavior is verified
- Keep the test suite fast enough to run frequently during development
- Treat a failing test as a blocking issue — fix it before moving on
- Include tests in the continuous integration pipeline so they run on every change
- Ensure tests cover edge cases and error paths, not just the happy path

## Sources

- Beck, Kent. *Extreme Programming Explained: Embrace Change*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
- Fowler, Martin. "BeckDesignRules." https://martinfowler.com/bliki/BeckDesignRules.html
