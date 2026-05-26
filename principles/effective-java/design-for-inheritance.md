# EFFECTIVE-JAVA-DESIGN-FOR-INHERITANCE - Design and Document for Inheritance, or Prohibit It

**Layer:** 2 (contextual)
**Categories:** object-oriented, maintainability, api-design
**Applies-to:** java, kotlin, csharp
**Summary:** Document self-use of overridable methods and mark classes `final` unless explicitly designed for inheritance.

## Principle

Design and document a class for inheritance, or else prohibit it. A class that is designed for inheritance must document precisely which overridable methods it calls internally (self-use), and must test it with subclasses before release. If you have not done this work, mark the class `final` or make all constructors package-private with static factories.

## Why it matters

Inheritance exposes implementation details. If a class's internal method calls its own overridable methods, a subclass that overrides those methods can break the superclass's invariants in ways neither party intended. The only safe inheritance is inheritance by deliberate design - everything else is accidental and fragile.

## Violations to detect

- Non-final classes whose Javadoc says nothing about which methods call which other overridable methods
- Superclasses that call overridable methods from constructors (the overridden method runs before the subclass constructor initialises fields)
- Classes that evolved over time and accumulated subclasses that depend on implementation details not guaranteed by the spec
- Extending concrete classes rather than abstract classes or interfaces

## Good practice

- Mark classes `final` unless designed for inheritance
- If designing for inheritance: document all self-use of overridable methods; test with concrete subclasses before release; never call overridable methods from constructors
- Prefer abstract classes with template methods or interfaces with default methods for intentional extension points
- In Kotlin, all classes are `final` by default - use `open` intentionally

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 19: "Design and document for inheritance or else prohibit it."
