# CODE-SMELLS-INSIDER-TRADING - Insider Trading

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, coupling
**Applies-to:** all
**Summary:** Decouple classes that access each other's private internals excessively by moving or hiding shared data.

## Principle

Insider Trading (also called Inappropriate Intimacy) occurs when two classes are too deeply entangled - one class accesses the private parts of another far more than is healthy. They spend too much time accessing each other's private data and methods, creating a tight bidirectional coupling that makes them hard to change or test independently.

## Why it matters

Classes that know too much about each other's internals become entangled. Changing one requires understanding and often changing the other. The boundary between them becomes meaningless, effectively creating one big blob that violates encapsulation.

## Violations to detect

- Class A calls many private or package-private methods of Class B, or accesses fields directly
- Two classes that have a large number of bidirectional dependencies
- A class that navigates deeply into another class's internal structure (related to Law of Demeter)
- Subclasses that use a parent's protected fields directly instead of going through the parent's interface

## Good practice

- Move methods and fields to reduce the dependency between the two classes
- Extract a third class to hold the shared interests if both classes need the same data
- Replace bidirectional association with unidirectional where possible
- Use delegation and well-defined interfaces to establish a clear boundary

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
