# CODE-SMELLS-REFUSED-BEQUEST - Refused Bequest

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, object-oriented
**Applies-to:** all
**Summary:** Replace inheritance with composition when a subclass rejects significant portions of its parent's interface.

## Principle

A subclass that does not want or need the methods or data it inherits from its parent has a Refused Bequest. The subclass refuses part of its inheritance - overriding methods to do nothing, throwing unsupported operation exceptions, or simply ignoring inherited state. This usually signals a misuse of inheritance where there is no true "is-a" relationship.

## Why it matters

Refused Bequest violates Liskov Substitution: if a subclass silently ignores or rejects behavior the parent guarantees, callers that depend on the parent contract will be surprised. It also indicates that the inheritance hierarchy does not reflect the real-world domain.

## Violations to detect

- A subclass that overrides several parent methods to throw `UnsupportedOperationException` or `NotImplementedException`
- A subclass that overrides methods to do nothing (empty bodies) simply to suppress inherited behavior
- A class that inherits fields it never uses
- A hierarchy created purely for code reuse where there is no conceptual subtype relationship

## Good practice

- If the subclass does not want the behavior, replace inheritance with delegation (Composition over Inheritance)
- If the subclass uses some but not all of the parent's interface, use Extract Superclass or Replace Subclass with Delegate
- Accept Refused Bequest when the subclass simply doesn't need a subset of behaviors but the LSP contract is otherwise preserved

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
