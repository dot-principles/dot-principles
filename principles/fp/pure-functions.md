# FP-PURE-FUNCTIONS — Pure functions

**Layer:** 1 (universal)
**Categories:** functional-programming, software-design, maintainability, testability
**Applies-to:** all
**Summary:** Write functions that always return the same output for the same input and cause no observable side effects.

## Principle

A pure function always produces the same output for the same input and causes no observable side effects — it neither reads from nor writes to anything outside its own arguments and return value. Pure functions are fully described by their type signature and their input/output relationship, with no hidden dependencies on global or mutable state.

## Why it matters

Impure functions are hard to test in isolation, difficult to reason about, and create hidden dependencies that cause bugs when state changes unexpectedly. Pure functions are trivially unit-testable, safely memoizable, and can be composed, parallelised, or reordered without risk — the compounding of these properties is what makes functional codebases easier to maintain at scale.

## Violations to detect

- Functions that read from or write to global variables, singleton state, or class fields
- Functions with return type `void`/`Unit` that are not at an explicit effect boundary
- Functions that call `Date.now()`, `Math.random()`, or similar non-deterministic primitives in the middle of business logic
- Functions that throw exceptions rather than returning error values
- Functions that mutate one of their arguments in place

## Inspection

- `grep -rn "Math\.random\|Date\.now\|new Date()" --include="*.ts" --include="*.js" $TARGET` | MEDIUM | Non-deterministic calls that make functions impure

## Good practice

- Extract all I/O, randomness, and time access to the edges of the system; pass the results in as parameters
- Return new values instead of mutating arguments; use `Object.freeze`, `readonly`, or immutable data libraries to enforce this
- Prefer functions that return `Result`/`Either` over functions that throw, to keep the signature honest
- If a function's only purpose is a side effect (logging, writing to disk), name and isolate it explicitly rather than burying the effect inside business logic

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 1.
- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Section 1.1.
