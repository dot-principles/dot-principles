# EFFECTIVE-JAVA-OVERRIDE-EQUALS-CONTRACT — Obey the General Contract When Overriding equals and hashCode

**Layer:** 1 (universal)
**Categories:** object-oriented, correctness, java
**Applies-to:** java, kotlin, scala
**Summary:** Override `equals` only when fulfilling the full reflexive-symmetric-transitive contract, and always override `hashCode` too.

## Principle

When you override `equals`, obey its general contract: it must be reflexive, symmetric, transitive, consistent, and `equals(null)` must return `false`. Always override `hashCode` whenever you override `equals` — objects that are equal must have the same hash code. Violating either contract breaks collections (HashMap, HashSet) and any code that relies on equality.

## Why it matters

Broken `equals`/`hashCode` produces mysterious bugs in collections: objects cannot be found after insertion, sets contain duplicates, and maps behave unpredictably. These bugs are hard to diagnose because the symptoms appear far from the cause.

## Violations to detect

- `equals` is overridden but `hashCode` is not (or vice versa)
- `equals` is not symmetric: `a.equals(b)` returns true but `b.equals(a)` returns false
- `equals` between different types in a hierarchy: subclass `equals` mixes with superclass `equals` producing non-transitive results
- Using mutable fields in `hashCode`, causing objects stored in hash-based collections to become unfindable after mutation

## Good practice

- Use `@Override` on both `equals` and `hashCode` to ensure they stay in sync
- Follow the recipe: check `==`, check `instanceof`, cast, compare all significant fields
- Use IDE-generated or library-generated `equals`/`hashCode` (Lombok `@EqualsAndHashCode`, Java 16+ records, Kotlin data classes)
- Do not include mutable fields in `hashCode` if instances will be stored in hash-based collections

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 10: "Obey the general contract when overriding equals." Item 11: "Always override hashCode when you override equals."
