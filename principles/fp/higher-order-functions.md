# FP-HIGHER-ORDER-FUNCTIONS - Higher-order functions

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design, abstraction
**Applies-to:** all
**Summary:** Treat functions as first-class values and abstract control structures via higher-order functions to eliminate boilerplate.

## Principle

A higher-order function is one that accepts other functions as arguments, returns a function as its result, or both. Treating functions as first-class values allows behaviour itself to be abstracted and parameterised - the same control structure can be reused with different logic by passing a different function, eliminating the need for repetitive boilerplate.

## Why it matters

Without higher-order functions, common patterns like "apply this transformation to every element", "retry this operation on failure", or "run this block with a resource and release it afterwards" must be reimplemented at every call site. Higher-order functions capture these patterns once; callers supply only the varying behaviour. This reduces duplication, isolates concerns, and makes control flow patterns testable in isolation.

## Violations to detect

- Repeated `for`/`while` loop structures that differ only in the body - candidates for `map`, `filter`, or `reduce`
- Copy-pasted try/catch/finally blocks that differ only in the operation performed inside - candidates for a higher-order wrapper
- Strategy or Template Method patterns implemented with subclassing where a function parameter would suffice
- Code that constructs a class solely to pass behaviour into another class (anonymous class as poor-man's lambda)

## Good practice

- Prefer `map`, `filter`, `reduce`/`fold`, `flatMap` over hand-written loops for collection transformations
- Capture recurring control patterns (retry, timeout, transaction, resource-acquisition) in higher-order functions that accept a block/lambda for the varying part
- Use function types in signatures rather than single-method interfaces where the language supports it
- Return functions from factory functions to specialise behaviour without subclassing

## Sources

- Hughes, John. "Why Functional Programming Matters." *The Computer Journal*, 32(2), 1989. https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf
- Abelson, Harold and Sussman, Gerald Jay. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. ISBN 978-0-262-51087-5. Chapter 1.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 2.
