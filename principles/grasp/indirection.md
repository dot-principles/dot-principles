# GRASP-INDIRECTION — Indirection

**Layer:** 2 (contextual)
**Categories:** software-design, coupling-reduction, architecture
**Applies-to:** all
**Summary:** Introduce an intermediary object to decouple two components so each can vary independently.

## Principle

Assign responsibility to an intermediate object to mediate between two components in order to avoid direct coupling between them. The intermediary decouples the components so each can vary independently.

## Why it matters

Direct coupling between two components means a change in either forces a change in the other. An intermediary — adapter, broker, facade, or message channel — absorbs the variation and allows each side to evolve without affecting the other.

## Violations to detect

- Two high-level modules directly importing each other's concrete types
- A component knowing the full interface of a remote service rather than talking through a client abstraction
- UI components directly querying databases or calling infrastructure services
- Cross-layer dependencies bypassing the intended architectural boundary

## Good practice

- Introduce an adapter to decouple your code from a third-party library's API
- Use a message broker or event bus to decouple publishers from subscribers
- Apply a facade to hide a complex subsystem behind a simple interface
- Use a repository to decouple domain logic from the persistence mechanism

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
- Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. *Design Patterns*. Addison-Wesley, 1994. ISBN 978-0-20-163361-0.
