# CODE-SMELLS-PRIMITIVE-OBSESSION — Primitive Obsession

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Replace primitive types used as domain concepts with small, named domain objects that encapsulate behavior.

## Principle

Primitive Obsession is the tendency to use built-in types — strings, integers, floats — to represent domain concepts that deserve their own small objects. A phone number is not a string; money is not a float; a ZIP code is not an integer. When primitives stand in for domain concepts, validation and behaviour scatter across the codebase instead of living in one place.

## Why it matters

Primitives carry no domain semantics and no constraints. A `String` can hold anything, so the system must repeatedly validate, parse, and interpret it. Small value objects encapsulate validation and behaviour, prevent invalid states, and make method signatures self-documenting.

## Violations to detect

- Strings used for phone numbers, email addresses, currencies, identifiers, or status codes
- Integers or floats used for money, percentages, or quantities without units
- Repeated validation of the same primitive value in multiple places
- Type codes or status fields represented as raw integers or strings instead of enumerations or objects

## Good practice

- Replace Data Value with Object: wrap the primitive in a small class that enforces validity on construction
- Replace Type Code with Subclasses or with State/Strategy when the primitive controls conditional logic
- Use the language's type system (enums, value types, branded types) to prevent misuse
- Give the new type a name from the domain vocabulary, not a technical name

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
