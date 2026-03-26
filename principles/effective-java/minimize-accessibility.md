# EFFECTIVE-JAVA-MINIMIZE-ACCESSIBILITY — Minimize Accessibility of Classes and Members

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Declare every class and member as inaccessible as possible to enforce encapsulation and hide implementation details.

## Principle

Make each class or member as inaccessible as possible. A well-designed component hides all of its implementation details, cleanly separating its API from its implementation. This information hiding — the single most important factor that distinguishes a well-designed component from a poorly designed one — allows components to be developed, tested, optimised, and understood in isolation.

## Why it matters

The more accessible a class or member is, the more commitments you make to external consumers. Public fields and methods become part of your API contract and are difficult to change or remove without breaking clients. Restricting access preserves your freedom to evolve the implementation.

## Violations to detect

- Classes or members declared `public` when `package-private` (default) would suffice
- Instance fields that are `public` or `protected` instead of `private` with accessor methods
- Mutable fields exposed through a public API without defensive copying
- Public classes that exist only to support the implementation of another class (should be nested or package-private)

## Good practice

- Start with the most restrictive access level and widen only when required by a real use case
- Make instance fields `private` and expose them through accessor methods only if needed
- For public classes, favour `private` fields; for package-private classes, package-private fields are acceptable
- Use the module system (Java 9+) to further restrict accessibility beyond individual access modifiers

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 15: "Minimize the accessibility of classes and members."
