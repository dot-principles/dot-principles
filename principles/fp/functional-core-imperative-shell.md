# FP-FUNCTIONAL-CORE-IMPERATIVE-SHELL - Functional core, imperative shell

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design, testability, architecture
**Applies-to:** all
**Summary:** Put all business logic in a pure functional core and confine I/O and side effects to a thin imperative shell.

## Principle

Structure programs with a pure functional core - containing all business logic as data transformations - surrounded by a thin imperative shell that handles I/O, side effects, and integration with the outside world. The shell translates real-world inputs into data, calls the core to transform it, and translates the output back into real-world effects. The core never performs I/O; the shell contains minimal logic.

## Why it matters

When business logic is interleaved with I/O (database reads, API calls, file writes), testing requires mocking or faking every external dependency. Separating the core from the shell means the business logic - the part most likely to be complex and buggy - can be tested with plain input/output assertions, no mocks required. The shell, being thin and mechanical, rarely contains bugs worth testing.

## Violations to detect

- Service classes or functions that mix domain calculations with database queries or HTTP calls in the same body
- Business rules that cannot be tested without setting up external infrastructure
- Domain objects that call repositories, loggers, or external services directly
- Functions that compute a result and then immediately perform an I/O action with it in the same scope

## Good practice

- Identify the pure transformation at the heart of each use case and express it as a function from inputs to outputs with no I/O
- Write the shell as a sequence: gather all inputs via I/O → call the pure core → execute the resulting effects
- Prefer returning a description of effects (a command object, an event list, a set of instructions) from the core rather than performing them - let the shell execute what the core decided
- Test the core with pure unit tests; test the shell with integration tests focused on wiring correctness, not business logic

## Sources

- Bernhardt, Gary. "Boundaries." Strange Loop conference talk, 2012. https://www.destroyallsoftware.com/talks/boundaries (accessed 2026-03-16).
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 13.
- Wlaschin, Scott. *Domain Modelling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-329-4. Chapter 9.
