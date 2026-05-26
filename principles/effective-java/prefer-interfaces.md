# EFFECTIVE-JAVA-PREFER-INTERFACES - Prefer Interfaces to Abstract Classes

**Layer:** 2 (contextual)
**Categories:** software-design, object-oriented, api-design
**Applies-to:** java, kotlin, scala
**Summary:** Define types with interfaces rather than abstract classes; use abstract classes only for skeletal implementations.

## Principle

Prefer interfaces over abstract classes for defining types. Existing classes can easily be retrofitted to implement an interface; they cannot be retrofitted to extend an abstract class. Interfaces are ideal for defining mixins (optional additional behaviors). Abstract classes can be used for skeletal implementations that pair with an interface, but the interface should define the type.

## Why it matters

Java's single-inheritance constraint means that a class extending an abstract class cannot extend anything else. Interfaces allow classes to participate in multiple type hierarchies, support mixin-like behavior, and can be retrofitted onto existing classes without disrupting their inheritance hierarchy.

## Violations to detect

- Defining types as abstract classes that could be defined as interfaces, locking consumers into a single-inheritance slot
- An abstract class with only one abstract method that could be an interface (or a functional interface)
- Requiring callers to extend an abstract class to use a service, preventing them from extending their own base class

## Good practice

- Define types with interfaces; provide optional skeletal implementations via abstract classes (the AbstractXxx pattern)
- Use default interface methods for simple shared logic that doesn't require state
- In newer Java, sealed interfaces can combine the benefits of interfaces with constrained subtype sets

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 20: "Prefer interfaces to abstract classes."
