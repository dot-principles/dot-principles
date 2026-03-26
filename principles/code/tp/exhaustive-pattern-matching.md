# CODE-TP-EXHAUSTIVE-PATTERN-MATCHING — Use exhaustive pattern matching — handle all cases

**Layer:** 2
**Categories:** type-safety, correctness
**Applies-to:** all (especially typed languages)
**Summary:** Use exhaustive pattern matching so the compiler enforces that every variant of a type is handled.

## Principle

When branching on a value that has a known set of variants — an enum, a discriminated union, a sealed class hierarchy — use exhaustive pattern matching to ensure every case is handled. The compiler should produce an error when a new variant is added and existing match expressions do not cover it. A catch-all default branch should be avoided unless there is a genuine "all others" semantic, because it silently swallows new variants.

## Why it matters

Forgetting to handle a case is one of the most common sources of bugs when extending a system. When a developer adds a new order status, a new message type, or a new error variant, every place in the code that branches on that type must be updated. Exhaustive matching turns this from a grep-and-hope exercise into a compiler-enforced guarantee: the code will not compile until every match site handles the new variant.

## Violations to detect

- Switch/match statements with a default/wildcard branch that swallows unknown variants silently
- If-else chains on enum values that do not cover all cases
- String comparisons used to branch on values that should be typed variants
- New variants added to a union or enum without updating all match expressions (caught by the compiler in languages with exhaustiveness checking, but missed in languages without it)
- Catch-all handlers that log and ignore unrecognized variants rather than failing explicitly

## Good practice

- Use pattern matching constructs that the compiler checks for exhaustiveness (`match` in Rust/F#/Scala, `when` in Kotlin with sealed classes, `switch` with exhaustiveness in TypeScript)
- Avoid default/wildcard cases unless the semantics genuinely apply to all future variants
- In languages without exhaustiveness checking (e.g., Java `switch` before JDK 21), add a default branch that throws an explicit error for unhandled cases
- When adding a new variant to a union type, intentionally let the compiler errors guide you to every call site that needs updating
- Prefer flat pattern matches over nested if-else chains — they are easier to read and easier for the compiler to verify

## Sources

- Wlaschin, Scott. *Domain Modeling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-254-1.
- Peyton Jones, Simon et al. "A Static Semantics for Haskell." Journal of Functional Programming, 2003.
