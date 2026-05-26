# FP-CURRYING - Currying and partial application

**Layer:** 2 (contextual)
**Categories:** functional-programming, software-design, abstraction
**Applies-to:** all
**Summary:** Use currying and partial application to progressively specialise generic functions without duplication.

## Principle

Currying transforms a function of multiple arguments into a chain of single-argument functions, each returning the next function in the chain until all arguments have been supplied. Partial application fixes some arguments of a function to produce a more specialised function. Together they allow generic functions to be progressively specialised into context-specific ones without duplication.

## Why it matters

Functions that require all arguments at the same point and place are difficult to reuse in contexts where some arguments are known early and others late. Currying and partial application eliminate this friction: a general function can be partially applied at the point where some arguments are known, producing a specialised function that can be passed and applied elsewhere - enabling composition and reuse without wrapper functions.

## Violations to detect

- Wrapper functions or lambdas whose sole purpose is to pre-fill arguments of a more general function
- Functions with configuration or context objects passed as the first argument at every call site instead of being partially applied once
- Duplicated logic that differs only in one fixed parameter value
- Factory methods or builder patterns used to specialise behaviour where partial application would suffice

## Good practice

- In languages that support curried function syntax (Haskell, F#, Elm), prefer curried functions by default
- In other languages, use partial application libraries or utility functions (`_.partial`, `fp-ts/function`, `functools.partial`)
- Put the most-likely-to-be-partially-applied arguments first (configuration, predicates, comparators); put the data argument last
- Use partial application to create domain-specific variants of general utilities: `const validateEmail = validate(emailRegex)` rather than always calling `validate(emailRegex, input)`

## Sources

- Bird, Richard and Wadler, Philip. *Introduction to Functional Programming*. Prentice Hall, 1988. ISBN 0-13-484197-7. Chapter 1.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 4.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 2.
