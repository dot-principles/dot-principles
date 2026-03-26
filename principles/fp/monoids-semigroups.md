# FP-MONOIDS-SEMIGROUPS — Monoids and semigroups

**Layer:** 2 (contextual)
**Categories:** functional-programming, abstraction, software-design
**Applies-to:** all
**Summary:** Identify associative binary operations and identity elements in domain types to enable generic, parallelisable aggregation.

## Principle

A semigroup is a type with an associative binary operation for combining two values of that type. A monoid is a semigroup that additionally has an identity element — a neutral value that, when combined with any other value, returns that value unchanged. Recognising these algebraic structures in your domain types enables generic, composable, and parallelisable aggregation operations without ad-hoc special cases.

## Why it matters

Many common operations — concatenating strings, adding numbers, merging maps, combining validation errors — share the same algebraic structure. When this structure is made explicit, the same generic `fold`/`reduce` implementation works for all of them, and associativity guarantees that the operation can be split across threads and recombined without changing the result. Monoids also make the identity element explicit, eliminating the need for special handling of empty collections.

## Violations to detect

- Custom fold/reduce implementations for each type that are structurally identical but not unified under a common abstraction
- Aggregation loops that handle the empty case with a special branch instead of using the monoid identity element as the starting value
- Combining operations that are not associative being used in parallel reduction (e.g., subtraction, division)
- Missing identity value causing `reduce` to fail on empty collections when `fold` with an identity would be safe

## Good practice

- Identify monoid instances in your domain: `(String, "", ++)`, `(Int, 0, +)`, `(List<A>, [], ++)`, `(Map<K,V>, {}, mergeWith(valueMonoid))`, `(Boolean, true, &&)`, `(Boolean, false, ||)`
- Use `fold` (with the monoid identity as the starting accumulator) rather than `reduce` (which requires a non-empty collection) to avoid partiality
- When combining complex domain objects, implement `combine` as a method and use it consistently rather than inline field-by-field merging
- Use associativity to parallelise expensive aggregations: split the collection, combine each partition in parallel, then combine the partition results

## Sources

- Chiusano, Paul and Bjarnason, Rúnar. *Functional Programming in Scala*. Manning, 2014. ISBN 978-1-61729-065-7. Chapter 10.
- Hutton, Graham. *Programming in Haskell*, 2nd ed. Cambridge University Press, 2016. ISBN 978-1-316-62622-1. Chapter 12.
- Milewski, Bartosz. *Category Theory for Programmers*. Self-published, 2019. https://github.com/hmemcpy/milewski-ctfp-pdf (accessed 2026-03-16). Chapter 3.
