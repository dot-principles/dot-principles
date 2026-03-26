# EFFECTIVE-JAVA-DESIGN-INTERFACES-FOR-POSTERITY — Design Interfaces for Posterity

**Layer:** 2 (contextual)
**Categories:** api-design, maintainability
**Applies-to:** java, kotlin
**Summary:** Audit every default method added to an existing interface against all known implementations before release.

## Principle

Think carefully before adding default methods to existing interfaces. Default methods in interfaces are added to all implementations without the implementors' consent. If a default method's preconditions are not satisfied by every existing implementation, it will compile but produce incorrect behavior or exceptions at runtime.

## Why it matters

Before Java 8, an interface was a binding contract: any class that compiled against it was guaranteed to implement every method. Default methods break this guarantee. An existing implementation may not meet the preconditions of a newly added default method, silently producing wrong results or throwing exceptions in production.

## Violations to detect

- Adding a non-trivial default method to a widely-implemented public interface without auditing all known implementations
- Default methods that modify shared state or have complex preconditions that may not hold for all existing implementations
- Assuming that a default method is "safe" because it compiles — correct compilation is necessary but not sufficient

## Good practice

- Design interfaces correctly the first time; it is much easier to add methods to interfaces in a new release than to fix a bad default method
- Test default methods against all known implementations before releasing
- Declare default methods only when they have trivially safe semantics for all conceivable implementations
- Prefer providing a separate utility class or a companion abstract class for non-trivial shared behavior

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 21: "Design interfaces for posterity."
