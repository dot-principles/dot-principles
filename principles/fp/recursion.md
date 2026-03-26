# FP-RECURSION — Recursion as primary iteration

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design
**Applies-to:** all
**Summary:** Express repetition through recursive functions with explicit base and recursive cases instead of mutable loop variables.

## Principle

In functional programming, repetition is expressed through recursive function calls rather than mutable loop variables. A recursive function decomposes its problem into a base case (solved directly) and a recursive case (solved by reducing the problem and delegating to itself). This makes the termination condition and the inductive structure of the problem explicit in the code.

## Why it matters

Imperative loops rely on mutable state — a counter or index that is incremented on each iteration — which reintroduces shared mutable state at the micro level. Recursive functions express the same iteration without mutation: each call receives its inputs as arguments and produces its result as a return value. The structure of the recursion often mirrors the structure of the data, making the algorithm easier to understand and verify.

## Violations to detect

- Recursive functions without a clearly identified base case — risk infinite recursion
- Recursion over data structures that do not have a direct structural correspondence to the recursive structure (mismatch between data shape and algorithm shape)
- Using recursion where a standard higher-order function (`map`, `fold`, `filter`) already captures the pattern and would be clearer
- Recursion used to iterate a fixed number of times when a simple range/fold would be more readable

## Good practice

- Identify the base case first and ensure it is reachable from the recursive case with every call
- Mirror the recursive structure of the data: a function over a list has a base case for the empty list and a recursive case for `head :: tail`; a function over a tree recurses on left and right subtrees
- Prefer standard higher-order functions (`map`, `fold`, `filter`) over hand-written recursion for common patterns — they are more readable and already correct
- Use tail recursion (see FP-TAIL-CALL-OPTIMISATION) when the recursion depth may be large

## Sources

- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Section 1.2.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 6.
- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 3.
