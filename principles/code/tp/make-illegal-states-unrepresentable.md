# CODE-TP-MAKE-ILLEGAL-STATES-UNREPRESENTABLE - Make illegal states unrepresentable through types

**Layer:** 2
**Categories:** type-safety, correctness
**Applies-to:** all (especially typed languages)
**Summary:** Design types so that invalid domain states cannot be constructed, not merely discouraged by convention.

## Principle

Design your types so that invalid combinations of data cannot be constructed. If a state should not exist in your domain, the type system should make it impossible to express, not merely discouraged by convention or documented in comments. When the compiler rejects illegal states, entire categories of runtime bugs are eliminated at compile time.

## Why it matters

Runtime checks and validation are necessary at system boundaries, but within the core domain, relying on discipline and documentation to prevent invalid states is fragile. Developers forget checks, tests miss edge cases, and documentation goes stale. When the type system enforces invariants, the compiler becomes an automated correctness checker that never forgets, never gets tired, and runs on every build.

## Violations to detect

- Data structures with fields that are only valid in certain combinations, enforced by runtime checks rather than distinct types (e.g., a `status` string field and a `completedAt` nullable date that must be non-null only when status is "completed")
- Nullable fields used to represent the absence of a concept that should be modeled as a separate type
- Boolean fields that create impossible combinations (e.g., `isActive` and `isDeleted` both true)
- Classes or structs with partially initialized states that are valid objects but semantically meaningless
- Stringly-typed fields where an enum or union type would constrain values to the valid set

## Good practice

- Use discriminated unions (sum types) to represent states that have different associated data - each variant carries exactly the fields relevant to that state
- Replace boolean flag combinations with an enum that lists only the valid states
- Make constructors enforce invariants - if a value cannot exist without certain data, require that data at construction time
- Use the type system to distinguish between validated and unvalidated data (e.g., `EmailAddress` vs. raw `string`)
- When you find yourself writing "this should never happen" in a runtime check, ask whether the type system could prevent it instead

## Sources

- Minsky, Yaron. "Effective ML." Jane Street Tech Talk, 2010.
- Wlaschin, Scott. *Domain Modeling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-254-1. Chapter 4: "Understanding Types."
