# CODE-TS-TEST-DATA-BUILDER — Build test fixtures with the Test Data Builder pattern

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Use the Builder pattern to construct test fixtures, setting only the fields relevant to each scenario.

## Principle

Construct test fixtures using the Builder pattern rather than creating domain objects with large inline parameter lists. A Test Data Builder exposes a fluent API where only the fields relevant to the test are set; all others default to valid but irrelevant values. Tests express intent, not wiring.

## Why it matters

When domain object constructors change, tests that build objects inline break en masse. Builders centralise construction so a signature change requires one fix. More importantly, tests littered with irrelevant field values hide what actually matters for the scenario under test, making them harder to read and maintain.

## Violations to detect

- Test methods that construct domain objects using `new Foo(arg1, arg2, arg3, ...)` with five or more positional arguments
- The same large object construction duplicated across multiple test methods or files
- Test setup that sets fields unrelated to the behaviour being verified, with no indication that those fields are irrelevant
- Helper methods named `createFoo(...)` that accumulate parameters over time instead of using a builder

## Good practice

- Create a `FooBuilder` (or `FooFixture`) class with `withX(...)` methods and a `build()` method; set safe defaults in the constructor
- Use a static factory on the builder for the most common baseline: `FooBuilder.aValidFoo().withStatus(PENDING).build()`
- Keep builders close to the tests that use them — in a `testutil` or `fixtures` package
- Prefer one builder per aggregate root; compose builders for nested objects

## Sources

- Freeman, Steve and Pryce, Nat. *Growing Object-Oriented Software, Guided by Tests*. Addison-Wesley, 2009. ISBN 978-0-321-50362-6. Chapter 22 "Constructing Complex Test Data".
- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0. Chapter 26 "Object Mother / Test Data Builder".
