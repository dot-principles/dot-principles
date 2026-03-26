# FP-EQUATIONAL-REASONING — Equational reasoning

**Layer:** 2 (contextual)
**Categories:** functional-programming, correctness, software-design
**Applies-to:** all
**Summary:** Write pure, referentially transparent functions so program correctness can be verified by algebraic substitution.

## Principle

Equational reasoning is the practice of verifying program correctness by substituting equal expressions for equal expressions — the same algebraic manipulation used in mathematics. It is possible precisely because pure, referentially transparent functions behave like mathematical functions: `f(x)` always equals the same value for a given `x`, so it can be substituted for that value (or vice versa) without changing meaning.

## Why it matters

In an impure codebase, understanding a function call requires simulating the execution — tracking what state was mutated, in what order, by which concurrent thread. Equational reasoning replaces simulation with algebra: to verify a property, substitute expressions, simplify, and check that both sides reduce to the same value. This scales: a property proved once holds everywhere, not just for specific test inputs.

## Violations to detect

- Logic that cannot be reasoned about without knowing the sequence of prior calls (stateful, order-dependent behaviour)
- Tests that are required to run in a specific order because earlier tests set up state that later tests depend on
- Functions that produce different results when called twice with identical arguments (impurity masked as business logic)
- Code where extracting a sub-expression into a named variable changes the observable behaviour (due to side effects)

## Good practice

- Use pure functions as the default; this is a prerequisite for equational reasoning to apply
- Verify properties of composed functions algebraically: `map(f, map(g, xs))` should equal `map(compose(f, g), xs)` — write a test to confirm this rather than testing only specific examples
- Prefer laws-based reasoning when choosing abstractions: choose `map`/`flatMap` because they obey functor/monad laws, not just because they look familiar
- Document non-obvious algebraic properties of your domain types as comments or property-based tests

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. §2. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 1.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 1.
