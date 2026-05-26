# CODE-TS-HUMBLE-OBJECT - Extract logic from untestable shells into Humble Objects

**Layer:** 2 (contextual)
**Categories:** testing, quality, software-design

**Applies-to:** all
**Summary:** Extract logic from framework-coupled classes into a dependency-free Humble Object that is easy to test.

## Principle

When a class is hard to test because it is entangled with a framework, UI runtime, or external infrastructure, extract its logic into a plain, dependency-free class - the Humble Object. The shell class (UI widget, framework controller, message consumer) is left as thin as possible, delegating all meaningful work to the easily testable inner class.

## Why it matters

Framework glue and domain logic mixed in the same class force tests to spin up the entire framework just to exercise a few lines of business logic. The result is slow, brittle tests that are abandoned rather than maintained. Separating concerns lets the logic be exercised cheaply and the integration boundary be tested at a higher level.

## Violations to detect

- Controller or handler classes that contain non-trivial conditional logic or data transformations directly inside framework lifecycle methods (`onClick`, `onMessage`, `doGet`, `handle`, etc.)
- Service or component classes that cannot be instantiated in a unit test without a framework container, servlet context, or UI toolkit
- Classes whose public methods are untestable except through end-to-end tests because they depend on framework state (session, request context, event loop)
- Business logic embedded directly in framework annotations or aspect advice

## Good practice

- Apply the pattern at any hard seam: extract a `FooLogic` (or `FooService`) class with no framework imports; keep the framework class as a one-liner that delegates to it
- Pass dependencies through the constructor of the extracted class so they can be replaced with test doubles
- Name the extracted class after what it does, not after the framework artifact it was extracted from
- Test the extracted class with plain unit tests; use a narrower integration test for the framework shell

## Sources

- Meszaros, Gerard. *xUnit Test Patterns: Refactoring Test Code*. Addison-Wesley, 2007. ISBN 978-0-13-149505-0. Chapter 29 "Humble Object".
- Martin, Robert C. *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall, 2017. ISBN 978-0-13-468599-1. Chapter 23 "Presenters and Humble Objects".
