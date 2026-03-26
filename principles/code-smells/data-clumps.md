# CODE-SMELLS-DATA-CLUMPS — Data Clumps

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Extract recurring groups of related data fields into a named object rather than repeating them everywhere.

## Principle

When the same group of data items — three or more fields or parameters — appears together in multiple places, they are a Data Clump. These groups typically represent a concept that deserves its own object. A good test: if you deleted one of the items, would the others still make sense together? If so, they belong in a class.

## Why it matters

Data Clumps inflate parameter lists, duplicate the implicit knowledge of which values belong together, and force every consumer to manage the group manually. Introducing an object for the clump reduces parameter counts, provides a natural home for related behaviour, and makes the domain model more explicit.

## Violations to detect

- The same three or more parameters appearing together in multiple method signatures
- Fields like `startDate` and `endDate`, or `x`, `y`, `z` repeated across several classes
- Methods that pass the same set of values through multiple layers without bundling them
- Parallel arrays or parallel fields that always change together

## Good practice

- Introduce a Parameter Object or value object to bundle the related values (e.g., `DateRange`, `Coordinate`)
- Move behaviour that operates on the clump into the new object
- Replace long parameter lists with the new object, even if some callers only use part of it
- Look for Data Clumps in field declarations as well as method signatures

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
