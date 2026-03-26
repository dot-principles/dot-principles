# ARCH-MVC — Model-View-Controller (MVC)

**Layer:** 1 (universal)
**Categories:** architecture, separation-of-concerns, user-interface
**Applies-to:** all
**Summary:** Separate domain state, rendering, and user-input handling into Model, View, and Controller with no cross-responsibility.

## Principle

Separate an application into three distinct responsibilities: the Model (domain state and business rules), the View (rendering and display), and the Controller (translating user input into Model operations). Each component is responsible for exactly one concern; no component should take on the responsibilities of another.

## Why it matters

Without MVC separation, view code contains business rules, controllers contain rendering logic, and models contain presentation state — producing tightly coupled code that cannot be tested, reused, or changed in isolation. The pattern is foundational to the design of virtually every web framework, GUI toolkit, and UI architecture.

## Violations to detect

- Business logic or database queries in view templates, route handlers, or UI components
- Model objects that reference view types or return HTML/JSON directly
- Controllers that contain validation logic, calculation logic, or domain rules rather than delegating to the model
- View templates constructing domain objects directly instead of receiving them from the controller

## Good practice

- Controllers translate HTTP requests (or UI events) into model operations; they contain no business logic
- Models contain all domain state and rules; they know nothing about the view or HTTP
- Views render model state; they contain no logic beyond simple conditionals for display
- Test each layer independently: models with unit tests, controllers with request-level tests, views with snapshot or rendering tests

## Sources

- Krasner, Glenn E. & Pope, Stephen T. "A Description of the Model-View-Controller User Interface Paradigm in the Smalltalk-80 System." *Journal of Object-Oriented Programming*, 1988.
- Buschmann, Frank et al. *Pattern-Oriented Software Architecture Vol. 1*. Wiley, 1996. ISBN 978-0471958697. Chapter 4.
