# FP-TOTALITY - Totality

**Layer:** 2 (contextual)
**Categories:** functional-programming, type-safety, reliability, correctness
**Applies-to:** all
**Summary:** Write total functions that return a declared output type for every input; never throw, loop forever, or return null.

## Principle

A total function is defined for every value in its input domain and always produces a value of its declared output type - it never throws an exception, loops forever, or returns `null`/`undefined`. Totality is a stronger correctness guarantee than type-correctness: the type `A -> B` should be interpreted as "given any `A`, I will always produce a `B`", not "given some `A`s, I might produce a `B` or throw".

## Why it matters

Partial functions - those that crash or throw on some inputs - shift the burden of correctness from the type system to documentation and runtime testing. Every caller of a partial function must know and guard against its undefined inputs, and this knowledge is not encoded in the type. Total functions are safe to compose, safe to call generically, and safe to cache - they are reliable building blocks, whereas partial functions are landmines.

## Violations to detect

- Functions that throw exceptions (including `IllegalArgumentException`, `IndexOutOfBoundsException`) for inputs that are legal given their declared type
- Functions that return `null` or `undefined` instead of `Option`/`Maybe` to signal absence
- Pattern matches or `switch` statements without an exhaustive default that can crash on unexpected input
- Division, modulo, or array indexing without guards against divide-by-zero or out-of-bounds inputs
- `head`/`first` on a list without checking that the list is non-empty

## Inspection

- `grep -rn "throw new\|raise \|failwith\b" --include="*.ts" --include="*.py" --include="*.fs" $TARGET` | LOW | Thrown exceptions inside business logic - verify these are truly for programming errors, not recoverable conditions

## Good practice

- Use the type system to encode preconditions: replace `positiveInt: number` with a `PositiveInt` branded/newtype that can only be constructed with a checked constructor returning `Option<PositiveInt>`
- Return `Option<T>` instead of `T | null`, and `Either<Error, T>` instead of throwing, for all recoverable failure cases
- Make pattern matches exhaustive; use compiler flags that warn on non-exhaustive matches (`-Wall` in GHC, `strict` in TypeScript)
- Document any remaining partial functions clearly and push them to system boundaries (top-level error handlers, parsers) where partiality is expected

## Sources

- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 5.
- Pierce, Benjamin C. *Types and Programming Languages*. MIT Press, 2002. ISBN 978-0-262-16209-8. Chapter 8.
- Wlaschin, Scott. *Domain Modelling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-329-4. Chapter 5.
