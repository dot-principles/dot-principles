# CODE-TP-PREFER-SUM-TYPES - Prefer sum types (discriminated unions) over boolean flags or string types

**Layer:** 2
**Categories:** type-safety, correctness
**Applies-to:** all (especially typed languages)
**Summary:** Model multi-variant values as sum types, not booleans, strings, or integer codes.

## Principle

When a value can be one of several distinct alternatives, model it as a sum type (discriminated union, tagged union, sealed class, or Rust enum) rather than a boolean flag, a string, or an integer code. Each variant of the sum type carries exactly the data relevant to that case. Booleans answer only yes/no and do not scale; strings accept any value and invite typos; sum types enumerate exactly the valid alternatives and make the compiler enforce correctness.

## Why it matters

Boolean flags multiply combinatorially - two booleans create four states, three create eight, and most combinations are invalid. String-typed status fields accept any value, so typos compile and pass tests until they cause a production bug. Sum types restrict the domain to exactly the valid alternatives, prevent invalid values at compile time, and enable exhaustive pattern matching so that every code path is accounted for when a new variant is added.

## Violations to detect

- Boolean parameters that control behavior branching (e.g., `process(order, isExpress: true, isInternational: false)` instead of a `ShippingMethod` union)
- String fields used to represent a fixed set of states (`status: "pending" | "active" | "cancelled"` modeled as `string` rather than a union type)
- Integer codes or magic numbers used to distinguish variants (`type: 1`, `type: 2`)
- Multiple boolean flags on a data structure where only certain combinations are valid
- Switch statements on strings with no compile-time guarantee that all cases are handled

## Good practice

- Replace boolean flags with a named enum or union type that describes the intent (e.g., `PaymentMethod.CreditCard | PaymentMethod.BankTransfer` instead of `isCreditCard: boolean`)
- Use TypeScript discriminated unions, Kotlin sealed classes/interfaces, Rust enums, F# discriminated unions, or Swift enums with associated values
- Attach variant-specific data to each case rather than using optional fields (e.g., `Shape.Circle(radius)` vs. `Shape { kind: "circle", radius?: number, width?: number }`)
- When a new variant is needed, add it to the sum type and let the compiler identify every location that needs updating
- In languages without native sum types (e.g., Java before sealed classes), use the visitor pattern or sealed class hierarchies to approximate exhaustiveness

## Sources

- Wlaschin, Scott. *Domain Modeling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-254-1. Chapter 6: "Modeling with Types."
