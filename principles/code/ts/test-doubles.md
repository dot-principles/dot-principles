# CODE-TS-TEST-DOUBLES - Use test doubles judiciously

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Prefer real collaborators over test doubles; only mock external dependencies like networks and databases.

## Principle

Prefer real collaborators over test doubles (mocks, stubs, fakes) when practical. Test doubles are valuable for isolating external dependencies - network services, databases, clocks - but overusing them couples tests to implementation details and creates a false sense of confidence. A test that passes with mocks may still fail with real collaborators.

## Why it matters

Over-mocking produces tests that verify the wiring between objects rather than the behavior of the system. These tests pass even when the real integration is broken, giving false confidence. They also resist refactoring, since changing how objects collaborate requires rewriting mock expectations even when the observable behavior is unchanged.

## Violations to detect

- Mocking types that the team owns and that are fast to use directly
- Mock setups that replicate the internal logic of the collaborator being replaced
- Tests where more lines are devoted to mock configuration than to assertions
- Mocks returning mocks (long mock chains indicating a Law of Demeter violation in production code)
- Using mocks where a simple in-memory fake would be clearer and more reusable

## Good practice

- Use real objects when they are fast, deterministic, and have no external side effects
- Reserve test doubles for boundaries: network, file system, time, randomness, third-party services
- Prefer fakes (lightweight in-memory implementations) over mocks for complex collaborators
- When using mocks, stub queries and verify commands - avoid verifying every interaction
- Treat excessive mocking as a design signal: if a class needs many mocks, it may have too many dependencies

## Sources

- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0.
- Freeman, Steve; Pryce, Nat. *Growing Object-Oriented Software, Guided by Tests*. Addison-Wesley, 2009. ISBN 978-0-321-50362-6.
