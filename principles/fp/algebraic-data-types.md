# FP-ALGEBRAIC-DATA-TYPES - Algebraic data types (ADTs)

**Layer:** 2 (contextual)
**Categories:** functional-programming, type-safety, software-design
**Applies-to:** all
**Summary:** Model domain concepts with product and sum types to make invalid states unrepresentable at compile time.

## Principle

Algebraic data types are composite types constructed from two primitives: product types (records, structs, tuples - "this AND that") and sum types (variants, unions, enums with data - "this OR that"). Using ADTs to model domain concepts makes impossible states unrepresentable and forces exhaustive handling of every case, shifting a class of runtime errors to compile-time errors.

## Why it matters

When domain concepts are represented with primitive types or inheritance hierarchies, the type system cannot prevent the construction of nonsensical values, and case analysis requires runtime checks that are easily forgotten. ADTs invert this: the shape of the data is the documentation, the compiler enforces exhaustiveness, and adding a new variant immediately reveals every site that must handle it.

## Violations to detect

- Boolean flags on a record that represent mutually exclusive states (`isLoading`, `hasError`, `isSuccess` - use a sum type)
- Nullable fields that are only valid in some states (use a sum type with the field scoped to the relevant variant)
- `instanceof` or `typeof` chains in business logic that would be better expressed as pattern matching on a sum type
- Stringly-typed status fields (`status: string`) that have a finite set of valid values
- Inheritance hierarchies used to model alternatives rather than to share behaviour

## Good practice

- Model mutually exclusive states as sum types (`sealed class`, `union type`, `enum` with data, `Either`)
- Model "both required" relationships as product types (data classes, records, structs)
- Use exhaustive pattern matching on sum types so the compiler verifies all cases are handled
- Name variants after the domain concept they represent, not their technical shape (`Pending | Processing | Shipped | Delivered`, not `State1 | State2`)

## Sources

- Pierce, Benjamin C. *Types and Programming Languages*. MIT Press, 2002. ISBN 978-0-262-16209-8. Chapter 11.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 8.
- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 3.
