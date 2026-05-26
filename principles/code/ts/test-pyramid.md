# CODE-TS-TEST-PYRAMID - Maintain a deliberately unequal ratio of unit, integration, and E2E tests

**Layer:** 2 (contextual)
**Categories:** testing, quality

**Applies-to:** all
**Summary:** Build test suites as a pyramid: many fast unit tests, fewer integration tests, minimal end-to-end tests.

## Principle

Structure a test suite as a pyramid: many fast, focused unit tests at the base; fewer integration tests in the middle; and a small number of slow end-to-end tests at the top. The ratio reflects cost - unit tests are cheap to write, fast to run, and precise in their failure messages. E2E tests are expensive, slow, and fragile; they should cover only the most critical user journeys.

## Why it matters

Inverting the pyramid - many E2E tests and few unit tests - produces a suite that is slow, brittle, and hard to debug. When an E2E test fails, pinpointing the root cause requires manual investigation. A pyramid-shaped suite gives rapid feedback on exactly which unit of logic broke, keeping developer cycle time short and the build green.

## Violations to detect

- Test suites where E2E or integration tests outnumber unit tests
- Unit tests that spin up databases, file systems, or network connections (they belong in a higher tier)
- No unit tests at all - only integration or system-level tests for business logic
- CI pipelines with no test-tier separation, running all tests on every commit regardless of speed

## Good practice

- Target roughly 70% unit, 20% integration, 10% E2E as a starting heuristic - adjust based on system type
- Run unit tests on every save; integration tests on every commit; E2E tests on merge to the main branch
- Push tests as low as possible: if a behaviour can be verified with a unit test, do not write an integration test for it
- Clearly separate test tiers in directory structure and CI pipeline stages

## Sources

- Cohn, Mike. *Succeeding with Agile: Software Development Using Scrum*. Addison-Wesley, 2009. ISBN 978-0-321-57936-2. Chapter "The Test Automation Pyramid".
- Fowler, Martin. "TestPyramid." https://martinfowler.com/bliki/TestPyramid.html (2012).
- Humble, Jez and Farley, David. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-5. Chapter 4 "Implementing a Testing Strategy".
