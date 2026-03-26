# EFFECTIVE-JAVA-STATIC-FACTORY — Prefer Static Factory Methods over Constructors

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Prefer static factory methods over constructors for named, cached, or polymorphic instance creation.

## Principle

Instead of — or in addition to — public constructors, consider providing static factory methods. A static factory method is a static method that returns an instance of the class. Unlike constructors, factory methods have names, are not required to create a new object each time, and can return an object of any subtype of the declared return type.

## Why it matters

Static factory methods give API designers more control and expressiveness. A well-named factory method like `valueOf`, `of`, or `newInstance` communicates intent far better than a constructor overloaded on parameter types. Factory methods also enable instance caching, return type flexibility, and can reduce the verbosity of creating parameterized type instances.

## Violations to detect

- Multiple constructors whose parameter differences are unclear without reading documentation
- Constructors used to create instances that could be cached and reused (e.g., Boolean, small integers)
- Constructors that return exactly the declared type when a factory could return a more efficient subtype
- Classes that would benefit from descriptive creation method names but only offer constructors

## Good practice

- Use conventional names: `of`, `valueOf`, `getInstance`, `newInstance`, `from`, `create`
- Use factory methods to control instance creation — return cached instances or subclass instances as appropriate
- Keep public constructors when the class is simple and a factory method would add no clarity
- Document factory methods prominently, as they are less discoverable than constructors in IDE auto-complete

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 1: "Consider static factory methods instead of constructors."
