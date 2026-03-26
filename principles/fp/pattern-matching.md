# FP-PATTERN-MATCHING — Pattern matching

**Layer:** 2 (contextual)
**Categories:** functional-programming, type-safety, software-design
**Applies-to:** all
**Summary:** Use exhaustive pattern matching on algebraic data types to eliminate missing-case bugs at compile time.

## Principle

Pattern matching decomposes a value by its structure — matching against constructors, literal values, tuples, or nested shapes — and binds the components to local names in each branch. When pattern matching is exhaustive (the compiler verifies that every possible shape is handled), it eliminates missing-case bugs at compile time and is the natural way to process algebraic data types.

## Why it matters

Chain-of-`if` or `switch` statements on discriminating fields are fragile: they rely on the programmer to remember every case, and adding a new variant only produces a missing branch at runtime. Exhaustive pattern matching moves this check to compile time — adding a new ADT variant immediately produces compile errors at every match site that must be updated, making refactoring safe by default.

## Violations to detect

- `if-else` or `switch` chains on a type discriminant field (`type`, `kind`, `status`) without a compile-time exhaustiveness check
- `instanceof` chains that handle known variants but silently fall through on unknown ones
- Default/wildcard branches in a match that swallow newly added variants instead of forcing an update
- Throwing `UnsupportedOperationException` or similar as the default arm of a case expression

## Inspection

- `grep -rn "default:\|else {" --include="*.ts" --include="*.java" --include="*.kt" $TARGET` | LOW | Default/else branches in switch statements — verify they are intentional catch-alls, not missed cases

## Good practice

- Avoid wildcard (`_`) default arms on sum types you control; make every case explicit so the compiler will alert you when a new variant is added
- Nest patterns to decompose composite structures in a single match expression rather than multiple sequential checks
- Use guard conditions (`when`, `if`) in match branches for conditions that cannot be expressed by structure alone, but keep them simple
- Prefer pattern matching over `instanceof` casts followed by downcasting — it is safer, more expressive, and eliminates the intermediate `null`-check

## Sources

- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 5.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 3.
- Haskell 2010 Language Report. https://www.haskell.org/onlinereport/haskell2010/ (accessed 2026-03-16).
