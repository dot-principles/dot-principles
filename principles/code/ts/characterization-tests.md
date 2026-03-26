# CODE-TS-CHARACTERIZATION-TESTS — Write characterization tests before refactoring legacy code

**Layer:** 2 (contextual)
**Categories:** testing, quality, maintainability
**Applies-to:** all
**Summary:** Before refactoring legacy code, write characterization tests that pin its current behaviour as a safety net.
**Audit-scope:** limited — auditable as the absence of test coverage over code paths actively being modified; not detectable from static analysis alone

## Principle

Before modifying legacy code that lacks tests, write tests that pin its current behaviour — including quirks and bugs. The goal is not to verify that the behaviour is correct, but to detect any unintended change during the refactor. Once the characterization tests are in place, refactor with confidence and then add correctness tests for the desired post-refactor behaviour.

## Why it matters

Refactoring untested code without a safety net produces regressions that are discovered in production rather than at the desk. Characterization tests make the cost of refactoring predictable: if the tests pass after the change, no observed behaviour was accidentally broken.

## Violations to detect

- Code paths being actively modified (git diff) with no corresponding test file covering those paths
- Pull requests that change legacy modules where coverage reports show 0% line coverage for the changed files
- Refactoring commits that delete or rename functions without adding or updating tests first

## Good practice

- Write a test that calls the code as-is and asserts whatever it currently returns — even if that output is surprising
- Use the test name to document that this is a characterization: `characterizes_invoice_total_rounding_behaviour`
- Once the refactor is complete, replace characterization tests with intent-driven tests that assert what the code *should* do
- Treat a failing characterization test as "something changed" — investigate before assuming the change is correct

## Sources

- Feathers, Michael. *Working Effectively with Legacy Code*. Prentice Hall, 2004. ISBN 978-0-13-117705-5. Chapter 13 "I Need to Make a Change but I Don't Know What Tests to Write".
