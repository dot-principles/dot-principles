# EFFECTIVE-JAVA-ELIMINATE-UNCHECKED-WARNINGS - Eliminate Unchecked Warnings

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Eliminate all unchecked warnings; suppress only when type-safety is proven and suppression is scoped as narrowly as possible.

## Principle

Eliminate every unchecked warning that you can. Every unchecked warning represents a potential `ClassCastException` at runtime. If you cannot eliminate a warning and you can prove that the code is type-safe, then - and only then - suppress the warning with `@SuppressWarnings("unchecked")` on the narrowest possible scope, and add a comment explaining why it is safe.

## Why it matters

Generics provide compile-time type safety, but only if unchecked warnings are heeded. If you allow unchecked warnings to accumulate, they become noise, and real type-safety problems are buried among them. A clean compile with no unchecked warnings gives you confidence that no `ClassCastException` will occur at runtime due to generics.

## Violations to detect

- Unchecked cast warnings that have not been investigated or addressed
- `@SuppressWarnings("unchecked")` applied at class or method level instead of the narrowest possible scope
- Suppressed warnings without a comment explaining why the suppression is safe
- Raw types used where parameterized types are available (e.g., `List` instead of `List<String>`)

## Good practice

```java
// Violation - @SuppressWarnings on entire method; raw type used
@SuppressWarnings("unchecked")
public <T> T[] toArray(T[] a) {
    return (T[]) Arrays.copyOf(elements, size, a.getClass());
}

// Correct - suppress on narrowest scope with justification comment
public <T> T[] toArray(T[] a) {
    // Safe because the array we're copying into is of type T[],
    // and we created it with the caller's array class token.
    @SuppressWarnings("unchecked")
    T[] result = (T[]) Arrays.copyOf(elements, size, a.getClass());
    return result;
}
```

- Always use parameterized types rather than raw types
- When a cast is provably safe, suppress the warning on the narrowest scope - a local variable declaration, not an entire method
- Add a comment with every `@SuppressWarnings` explaining the reasoning
- Treat unchecked warnings with the same urgency as errors: investigate each one

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 27: "Eliminate unchecked warnings."
