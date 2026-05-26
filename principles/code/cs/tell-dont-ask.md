# CODE-CS-TELL-DONT-ASK - Tell, Don't Ask

**Layer:** 1 (universal)
**Categories:** software-design, object-oriented, encapsulation
**Applies-to:** all
**Summary:** Tell objects what to do; never ask for their data to make decisions externally.

## Principle

Tell objects what to do - don't ask them for their data, make a decision yourself, and then set something back on the object. Behaviour that uses an object's state should live inside that object, not outside it. Asking for state and then acting on it is a procedural style that breaks encapsulation; telling delegates the decision to the object that owns the data.

## Why it matters

Code that extracts state from objects and makes decisions about it externally scatters logic that belongs together. This creates Feature Envy, duplicates decision logic across callers, and makes objects easy to misuse. When the state changes (a new field, a new condition), all callers must be updated instead of just the object itself.

## Violations to detect

- Getters used solely to make a decision that the owning object could make internally
- Conditional logic spread across multiple callers that all ask the same object the same questions
- Code that calls `getX()`, checks the result, then calls `setY()` on the same object - the object could encapsulate that transition
- Service classes full of logic that operates on domain objects using only their getters (anemic domain model)

## Good practice

```java
// Violation - asking for state, deciding externally
if (order.getStatus() == Status.PENDING && order.getTotalAmount().compareTo(THRESHOLD) > 0) {
    order.setStatus(Status.UNDER_REVIEW);
}

// Correct - tell the order what happened; it decides internally
order.submitForReview(THRESHOLD);
```

- Move conditional logic that depends only on an object's own state into that object as a method
- Replace `if (obj.getX()) { obj.setY(...) }` patterns with a single `obj.doTransition(...)` call
- Accept that some data-transfer objects (DTOs, view models) are legitimately passive - the principle applies to domain objects with behaviour
- Law of Demeter and Tell Don't Ask reinforce each other: if you're navigating through an object's internals, you're probably also asking rather than telling

## Sources

- Hunt, Andrew, and David Thomas. *The Pragmatic Programmer: From Journeyman to Master*. Addison-Wesley, 1999. ISBN 978-0-201-61622-4. Tip 37, "Tell, Don't Ask."
- Fowler, Martin. "TellDontAsk." https://martinfowler.com/bliki/TellDontAsk.html (accessed 2026-03-16).
