# CODE-SMELLS-LOOPS — Loops

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, readability
**Applies-to:** all
**Summary:** Replace imperative loops that filter, transform, or accumulate with declarative pipeline operations.
**Audit-scope:** limited — imperative loops are detectable but whether a pipeline replacement is appropriate requires semantic judgment

## Principle

An imperative loop that filters, transforms, or accumulates data is harder to read than an equivalent pipeline operation. Pipeline operations — `map`, `filter`, `reduce`, and their language equivalents — declare *what* should happen to each element without the noise of index variables, accumulator initialisation, and push/append boilerplate. When a loop's body consists entirely of a filter condition, a transformation, or an accumulation, it should be replaced with the corresponding pipeline operation.

## Why it matters

Imperative loops mix the mechanics of iteration with the intent of the operation. A reader must scan the entire loop body to determine whether it is filtering, transforming, reducing, or doing something more complex. Pipeline operations make intent explicit at the call site: `items.filter(isActive).map(toDto)` communicates the operation in the method names without requiring the reader to parse a loop body. Replacing loops with pipelines also makes individual steps composable and independently testable.

## Violations to detect

- A `for`/`while` loop whose body consists of an `if` condition followed by pushing the current element to a result collection — replace with `filter`
- A `for`/`while` loop whose body transforms each element and pushes the result to a new collection — replace with `map`
- A `for`/`while` loop that accumulates a single scalar result (sum, count, concatenation) using a running variable — replace with `reduce`/`fold`
- Nested loops that flatten or cross-join collections where `flatMap` would be clearer
- Loop-based data transformations that chain multiple operations in a single body, making the stages hard to distinguish

## Good practice

- Refactor pure filter loops to `filter` / `where` / `select`: `items.filter(item => item.isActive())`
- Refactor pure transform loops to `map` / `select`: `items.map(item => toDto(item))`
- Refactor accumulation loops to `reduce` / `fold` / `aggregate`: `items.reduce((sum, x) => sum + x.value, 0)`
- Chain pipeline operations for multi-step processing: `items.filter(...).map(...).reduce(...)` is more readable than an equivalent loop with interleaved logic
- Keep each pipeline step small and named; extract a named function for non-trivial lambdas rather than using long inline expressions

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
