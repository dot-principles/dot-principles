# GRASP-LOW-COUPLING — Low Coupling

**Layer:** 1 (universal)
**Categories:** software-design, maintainability, dependency-management
**Applies-to:** all
**Summary:** Depend on stable abstractions and minimise the number of classes each class directly references.

## Principle

Assign responsibilities so that coupling remains low. A class should depend on as few other classes as possible, and those dependencies should be stable abstractions rather than volatile concretions.

## Why it matters

High coupling means a change in one class forces changes in many others — a ripple effect that makes the system fragile and expensive to evolve. Tightly coupled classes are also difficult to test in isolation, reuse in other contexts, or understand independently.

## Violations to detect

- A class that imports or directly references many unrelated classes
- Concrete class dependencies where an interface or abstract type would suffice
- Circular dependencies between modules or packages
- A class that breaks when an unrelated class is modified
- Tests that require instantiating many collaborators just to test one class

## Good practice

- Depend on abstractions (interfaces, abstract types) rather than concrete implementations
- Keep the number of collaborators per class small (the Law of Demeter: talk to immediate neighbours only)
- Organise code into cohesive modules with minimal cross-module dependencies
- Use dependency injection so coupling to construction is removed from business logic

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
- Yourdon, Edward, and Larry L. Constantine. *Structured Design*. Prentice Hall, 1979. ISBN 978-0-13-854471-3.
