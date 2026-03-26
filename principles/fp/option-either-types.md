# FP-OPTION-EITHER-TYPES — Model absence and errors with types

**Layer:** 2 (contextual)
**Categories:** functional-programming, type-safety, error-handling, reliability
**Applies-to:** all
**Summary:** Use Option and Either types to make absence and failure explicit in signatures, forcing exhaustive handling by callers.

## Principle

Use `Option`/`Maybe` to represent values that may legitimately be absent, and `Either`/`Result` to represent computations that may succeed with a value or fail with a structured error. These types make optionality and error paths visible in the type signature and force callers to handle both cases, eliminating the need for `null` checks and unchecked exceptions scattered throughout the codebase.

## Why it matters

`null` and unchecked exceptions are invisible in type signatures: a function that returns `User` when it can actually return `null` misleads every caller. `NullPointerException` and unhandled exceptions are among the most common runtime failures in production systems. Encoding absence and failure in the type system converts runtime surprises into compile-time obligations — the caller must explicitly decide what to do when a value is absent or an operation fails.

## Violations to detect

- Functions that return `null` or `undefined` to indicate absence rather than `Option`/`Maybe`
- Functions that throw exceptions for recoverable error conditions (user not found, validation failure) rather than returning `Either`/`Result`
- `null` checks scattered throughout business logic rather than at a single point of entry
- Ignored return values of functions that signal failure through their return type (e.g., unchecked `Optional` in Java)
- `try/catch` blocks around non-exceptional conditions in the middle of business logic

## Inspection

- `grep -rn "=== null\|== null\|!= null\|!== null" --include="*.ts" --include="*.js" $TARGET` | MEDIUM | Null checks that could be replaced with Option/Maybe types
- `grep -rn "throws\|throw new" --include="*.ts" --include="*.java" --include="*.kt" $TARGET` | LOW | Exception throwing — verify these are truly exceptional, not recoverable errors

## Good practice

- Return `Option<T>` / `Maybe T` for any operation that may legitimately produce no value (lookup by key, finding the first match)
- Return `Either<Error, T>` / `Result<T, E>` for operations that may fail with a domain-meaningful error (validation, parsing, I/O)
- Use `map` and `flatMap` to compose chains of optional/fallible operations without manual unwrapping at each step
- Unwrap `Option`/`Either` at the outermost layer (the shell), where the program must decide how to present the absence or error to the user

## Sources

- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 8.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapters 4–5.
- Wlaschin, Scott. *Domain Modelling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-329-4. Chapter 6.
