# CODE-TP-TYPE-STATE-MACHINES — Encode state machines in the type system

**Layer:** 2
**Categories:** type-safety, correctness
**Applies-to:** all (especially typed languages)
**Summary:** Encode distinct object states as separate types so invalid state transitions become compile-time errors.

## Principle

When a domain object transitions through distinct states with different allowed operations and data at each state, model those states as separate types rather than a single type with status flags. Each state type carries exactly the data available in that state, and functions that transition between states accept one state type and return another. The compiler then enforces that you cannot perform operations that are invalid for the current state.

## Why it matters

Most bugs in stateful systems come from performing an action in the wrong state: shipping an order that has not been paid, sending a confirmation email for a cancelled booking, or accessing fields that do not exist yet. When states are encoded as types, these bugs become compile errors. The type system documents the valid transitions and ensures that every code path respects the state machine, without relying on runtime checks that can be forgotten or bypassed.

## Violations to detect

- A single class with a `status` field and methods guarded by `if (status == ...)` checks that throw runtime exceptions for invalid states
- Optional/nullable fields that are "only valid when status is X" — requiring every consumer to know which fields are available in which state
- State transition methods that return the same type regardless of the target state, losing type information about what state the object is now in
- Business logic that checks the current state with `instanceof` or string comparison instead of pattern matching on typed states
- Documentation comments like "only call this after calling initialize()" where the type system could enforce the ordering

## Good practice

- Model each state as a distinct type or variant of a discriminated union: `Order.Pending`, `Order.Paid`, `Order.Shipped`, `Order.Delivered`
- Make transition functions accept one state and return another: `fun ship(order: Order.Paid): Order.Shipped`
- Ensure that each state variant carries only the data available in that state — `Order.Shipped` has a `trackingNumber`, `Order.Pending` does not
- Use the typestate pattern in languages that support it (Rust, TypeScript, Kotlin sealed hierarchies) to enforce valid operation sequences at compile time
- When the full typestate pattern is too heavyweight, at minimum use a sum type for the states to enable exhaustive matching on transitions

## Sources

- Wlaschin, Scott. *Domain Modeling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-254-1. Chapter 8: "Modeling Workflows as Pipelines."
- Coplien, James O. "The DCI Architecture: A New Vision of Object-Oriented Programming." Artima Developer, 2009.
