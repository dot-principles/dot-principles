# EFFECTIVE-JAVA-PREFER-DEPENDENCY-INJECTION - Prefer Dependency Injection to Hardwiring Resources

**Layer:** 1 (universal)
**Categories:** software-design, object-oriented, testability
**Applies-to:** all
**Summary:** Pass dependencies into constructors rather than hardwiring them as singletons or static utilities.

## Principle

Classes that depend on underlying resources should not hardwire those resources using static utility methods or singletons, and should not create the resources themselves. Instead, pass the resource (or a factory for it) into the constructor. Dependency injection makes classes more flexible, reusable, and testable.

## Why it matters

Hardwired dependencies make a class inflexible and untestable: you cannot substitute a test double, a different implementation, or a configuration-specific variant without modifying the class. Injecting dependencies makes them visible in the interface and allows callers to supply whatever variant is appropriate.

## Violations to detect

- A class that calls `new SomeDependency()` or accesses a singleton inside its constructor or methods
- Static utility classes that hold shared mutable resources (dictionaries, configuration, connections)
- Classes that use `static` fields for resources that vary per use or environment (e.g., a `static final Comparator`)

## Good practice

- Pass dependencies (resources) via the constructor
- Pass a factory (`Supplier<T>`, abstract factory) when the class needs to create multiple instances of the resource
- Use a dependency injection framework (Spring, Guice, Dagger) for complex graphs; use manual injection for simple cases
- Accept interfaces as constructor parameters, not concrete classes

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 5: "Prefer dependency injection to hardwiring resources."
