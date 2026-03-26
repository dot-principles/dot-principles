# CODE-SMELLS-ALTERNATIVE-CLASSES — Alternative Classes with Different Interfaces

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Unify classes that perform the same role under a common interface to eliminate hidden duplication.

## Principle

Alternative Classes with Different Interfaces occur when two or more classes do the same thing but have different method names or signatures, making them non-interchangeable. The duplication is hidden behind different names, preventing the use of polymorphism or a common interface.

## Why it matters

Hidden duplication means maintaining the same logic in multiple places. The inability to swap implementations means callers must know which class they are using and cannot benefit from polymorphism. Introducing a common interface or superclass removes the duplication and enables substitutability.

## Violations to detect

- Two classes that clearly serve the same purpose but have differently-named methods for the same operations (e.g., `UserEmailSender.sendWelcome()` and `CustomerMailer.dispatchGreeting()`)
- Code that cannot use either class in place of the other, forcing callers to import both
- Duplicated logic that emerged because two teams independently implemented the same abstraction

## Good practice

- Rename methods to match and extract a common interface both classes implement
- If one class is a subset of the other, use Move Function to bring them together
- Consider merging the two classes entirely if they truly serve the same purpose

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
