# FP-LAZY-EVALUATION - Lazy evaluation

**Layer:** 2 (contextual)
**Categories:** functional-programming, performance, software-design
**Applies-to:** haskell, scala, clojure, python, javascript, typescript
**Summary:** Defer computations until results are needed to decouple producers from consumers and enable infinite sequences.

## Principle

Lazy evaluation defers the computation of an expression until its result is actually needed, and may cache the result so the computation is not repeated. This separates the description of a computation from its execution, allowing producers of data (generators, infinite sequences, expensive computations) to be decoupled from consumers, and enabling programs to work with conceptually infinite data structures.

## Why it matters

Eager evaluation couples producers to consumers: a producer that generates values must produce all of them before a consumer can start consuming, even if the consumer only needs the first few. Laziness breaks this coupling - a consumer can demand exactly as many values as it needs and no more, making programs more modular and more efficient. It also enables natural expression of algorithms over infinite streams without special casing.

## Violations to detect

- Loading an entire collection into memory to take only the first N elements - should use a lazy sequence or iterator
- Computing expensive derived values unconditionally when they are only rarely used - should use lazy initialisation
- Manually implementing generators or pagination where a lazy sequence abstraction would be simpler
- Short-circuit evaluation not used in boolean expressions with expensive sub-expressions

## Good practice

- Use lazy sequences, generators, and iterators (`Stream` in Java/Scala, generators in Python/JS, `Seq` in Haskell) for pipelines over large or unbounded data
- Prefer lazy initialisation (`lazy val`, `Lazy<T>`, property with backing field) for expensive computed properties that are not always accessed
- Express infinite sequences naturally (the sequence of all natural numbers, an infinite retry stream) and let consumers decide termination
- Be aware that laziness can make space behaviour harder to reason about (lazy thunks can build up); profile before assuming laziness is always faster

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. §3-4. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Section 3.5.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 15.
