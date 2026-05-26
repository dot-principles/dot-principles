# CODE-TS-ARRANGE-ACT-ASSERT - Use the Arrange-Act-Assert pattern for test structure

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Structure every test in three explicit phases: Arrange, Act, and Assert.

## Principle

Structure each test in three distinct phases: Arrange (set up preconditions and inputs), Act (execute the behavior under test), and Assert (verify the expected outcome). This pattern, also described as the Four-Phase Test (with an implicit teardown phase), makes every test immediately readable by giving it a consistent, predictable shape.

## Why it matters

A consistent test structure reduces cognitive load when reading and writing tests. When every test follows the same shape, reviewers can quickly locate what is being set up, what is being exercised, and what is expected. Deviations from the pattern often signal a test that is doing too much or testing the wrong thing.

## Violations to detect

- Tests with assertions interleaved between multiple actions (act-assert-act-assert)
- Tests where setup, action, and verification are mixed together with no clear separation
- Tests with no visible act phase - asserting on fixture setup alone
- Tests that perform multiple unrelated actions before a single assertion block

## Good practice

- Visually separate the three phases with blank lines or comments if the language does not enforce structure
- Keep the Arrange phase focused - extract complex setup into helper methods or builders
- Limit the Act phase to a single statement or method call when possible
- Place all assertions at the end, verifying different facets of the same outcome

## Sources

- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0. Section: "Four-Phase Test."
