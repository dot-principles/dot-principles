# FP-REFERENTIAL-TRANSPARENCY — Referential transparency

**Layer:** 1 (universal)
**Categories:** functional-programming, software-design, maintainability
**Applies-to:** all
**Summary:** Write expressions that can be replaced by their evaluated values anywhere without changing program behaviour.

## Principle

An expression is referentially transparent if it can be replaced by its evaluated value anywhere in the program without changing the program's behaviour. This property is a direct consequence of purity: because a referentially transparent expression has no side effects and no hidden dependencies, it is equivalent to its result in all contexts.

## Why it matters

Without referential transparency, understanding a piece of code requires tracing its entire execution history and the global state at every call site — a combinatorial problem that grows with codebase size. Referential transparency collapses this: to understand a function call, you only need to know its arguments, not the history of the world.

## Violations to detect

- Calling the same function twice with the same arguments and receiving different results (stateful singletons, caches with side effects, counters)
- Functions whose return value depends on the order in which they were called
- Expressions that cannot be safely extracted into a variable without changing behaviour (due to side effects)
- Memoizing a function that actually produces different results for the same inputs (masking impurity)

## Good practice

- Use referential transparency as a design test: ask "could I replace this call with its cached result everywhere?" — if no, the expression is not transparent
- Isolate impure computations (I/O, time, randomness) at system boundaries and pass their results into a referentially transparent core
- Prefer expression-oriented code (functions that return values) over statement-oriented code (functions called for effect)

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 1.
- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 1.
