# CODE-SMELLS-MIDDLE-MAN — Middle Man

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, object-oriented
**Applies-to:** all
**Summary:** Remove or inline classes that do nothing but delegate to another class without adding meaningful logic.

## Principle

A Middle Man is a class where most of its methods do nothing but delegate to another class. If half or more of a class's public methods simply forward calls to a collaborator, the class is not contributing meaningful logic — it is a redundant intermediary. The delegating class can usually be removed, or replaced with direct access to the real class, or collapsed via a technique such as Remove Middle Man or inline delegation.

## Why it matters

A class that only passes messages adds a layer of indirection the reader must trace through without gaining any new understanding. Every method call becomes two: one to the middle man and one to the real object. When the middle man has no logic of its own, it cannot change what happens — it is pure overhead. Callers become coupled to both the middle man and the real class, and changes to the real class ripple through the middle man to all callers anyway.

## Violations to detect

- A class where the majority of its public methods consist of a single line that calls the same method on a field: `return this.delegate.foo(args)`
- A facade class whose methods are one-to-one wrappers around another class's methods with no added logic, validation, or transformation
- A service class that simply re-exposes a repository or third-party library's entire API unchanged
- Wrapper classes introduced "for future flexibility" that have never diverged from the wrapped interface

## Good practice

- Apply Remove Middle Man: let callers call the real object directly if there is no meaningful indirection
- Assess whether the middle man began as a facade over a volatile dependency — if the wrapped class is stable and the facade adds nothing, collapse them
- If the class started as meaningful and delegation crept in over time, consider whether to replace delegation with inheritance (sparingly) or introduce real responsibilities to justify the class
- Distinguish from intentional delegation patterns: a facade over a complex or unstable subsystem, or one that adapts an interface for a specific client, has value even when its methods are thin

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
