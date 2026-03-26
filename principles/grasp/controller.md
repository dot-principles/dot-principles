# GRASP-CONTROLLER — Controller

**Layer:** 2 (contextual)
**Categories:** software-design, responsibility-assignment, architecture
**Applies-to:** all
**Summary:** Route system events through a dedicated controller class; never embed coordination logic in UI or domain objects.

## Principle

Assign the responsibility of receiving or handling a system event to a class representing the overall system, a root object, a use-case scenario, or a session handler. The controller coordinates system operations; it does not perform the work itself.

## Why it matters

Without a controller, system event handling bleeds into UI components, domain objects, or scattered service methods. Controllers provide a clear boundary between the presentation layer and the domain, making use-case logic testable without a UI and keeping domain objects free of coordination logic.

## Violations to detect

- UI components (buttons, views, request handlers) containing business logic directly
- Domain objects processing UI events or HTTP request parameters
- No clear coordinator class — system operations scattered across the caller
- Fat controllers that contain business logic rather than delegating to domain objects

## Good practice

- A controller class per use-case (e.g., `ProcessOrderController`) that delegates to domain objects
- In MVC, the controller coordinates — it does not implement — business rules
- Keep controllers thin: receive the event, delegate to the domain, return a result
- Use the facade controller pattern (one controller per subsystem) for simpler systems

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
