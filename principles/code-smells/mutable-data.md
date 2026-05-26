# CODE-SMELLS-MUTABLE-DATA - Mutable Data

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, reliability
**Applies-to:** all
**Summary:** Minimize mutable state scope; prefer immutability and confine mutation to a single, explicit location.

## Principle

Mutable Data is the smell that arises when data can be changed from multiple places in ways that are difficult to trace, making it hard to understand what the data's value is at any given point and what code is responsible for changing it. The broader the scope of mutable state and the more code paths that can modify it, the greater the risk of unexpected interactions, stale reads, and bugs that are hard to reproduce. The remedy is to reduce the scope and visibility of mutation: make data immutable where possible, confine mutation to a single place, and use return values rather than side effects.

## Why it matters

Mutable state is one of the most common sources of difficult bugs. When a value changes unexpectedly, the developer must mentally trace every code path that could have written it. The more mutation is spread across the codebase - through public setters, passed-by-reference parameters that get modified, or widely accessible mutable fields - the harder this tracing becomes. This smell is distinct from Global Data (which is specifically about widely scoped access) and from Mutable Data as a concurrency concern: even in single-threaded code, excessive mutation within a single call stack produces code that is hard to reason about and test.

## Violations to detect

- Functions that modify their input parameters or objects passed by reference as a primary means of returning results
- Classes that expose public setters for all their fields, making them modifiable from any call site
- Mutable data structures (lists, maps, sets) passed between layers and modified in place by the receiving layer
- Long functions where the same variable is assigned multiple times with different values at different stages of computation
- "Out parameters" or flag fields set as side effects of a method rather than returned as a value

## Good practice

- Replace modifications of input parameters with return values; use the Command-Query Separation principle
- Restrict setters to only the fields that genuinely need post-construction mutation; make the rest final/readonly
- Prefer returning new collections rather than mutating a passed-in one; use `map`, `filter`, and `reduce` rather than modifying in place
- Encapsulate mutation: if state must change, confine all mutations to one method in one class, rather than letting callers reach in
- Use immutable value objects for data that represents a fact at a point in time (money, dates, measurements)

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
