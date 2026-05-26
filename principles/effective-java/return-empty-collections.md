# EFFECTIVE-JAVA-RETURN-EMPTY-COLLECTIONS - Return Empty Collections, Not Null

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Return empty collections or zero-length arrays instead of `null` to eliminate mandatory null checks in callers.

## Principle

Methods that return collections or arrays should return empty collections or zero-length arrays rather than `null`. Returning `null` forces every caller to write a null check before iterating or processing the result. Forgetting that check leads to `NullPointerException` at runtime - a bug that the compiler cannot catch.

## Why it matters

A `null` return value from a collection-returning method is a latent bug in every caller that forgets to check for it. Empty collections are valid, well-behaved objects: they iterate zero times, have size zero, and work correctly with streams and for-each loops. They eliminate an entire class of defensive-coding errors at no meaningful performance cost.

## Violations to detect

- Methods that return `null` instead of `Collections.emptyList()`, `Collections.emptySet()`, or an empty array
- Callers forced to null-check before iterating over a method's return value
- APIs that document "returns null if no results" instead of returning an empty collection
- Inconsistency within the same codebase: some methods return null, others return empty collections

## Good practice

```java
// Violation - null return forces defensive checks in every caller
List<Cheese> getCheeses() {
    return cheeseInStock.isEmpty() ? null : new ArrayList<>(cheeseInStock);
}

// Correct - always return a valid, iterable collection
List<Cheese> getCheeses() {
    return cheeseInStock.isEmpty()
        ? Collections.emptyList()
        : new ArrayList<>(cheeseInStock);
}
```

- Return `Collections.emptyList()`, `Collections.emptySet()`, or `Collections.emptyMap()` for immutable empty returns
- Allocate a shared empty array constant and reuse it rather than allocating `new T[0]` each time
- Use `Optional<T>` for single-valued returns that may be absent, but still return empty collections for multi-valued returns
- Apply this principle consistently across the entire API - callers should never have to guess

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 54: "Return empty collections or arrays, not nulls."
