# CODE-CS-DESIGN-BY-CONTRACT — Design by Contract

**Layer:** 2 (contextual)
**Categories:** software-design, correctness, object-oriented
**Applies-to:** all
**Summary:** Specify preconditions, postconditions, and invariants for every operation and enforce them explicitly.

## Principle

Every operation has a contract: a **precondition** the caller must satisfy before calling, a **postcondition** the implementation guarantees after returning, and a **class invariant** that holds at all observable points. The caller is responsible for meeting preconditions; the implementer is responsible for delivering postconditions. If a precondition is violated, the fault is the caller's — the implementation is free to fail fast.

## Why it matters

Undocumented and unenforced assumptions about inputs and outputs create latent bugs that surface far from their origin. Explicit contracts make assumptions part of the code, allow violations to be caught immediately at the call site, and clarify who is responsible when something goes wrong. They also enable substitutability: a subclass contract may weaken preconditions and strengthen postconditions (Liskov).

## Violations to detect

- Methods with no documented or enforced precondition that fail silently or crash deep in the call stack when given invalid input
- Postconditions never checked — method claims to return a sorted list but callers cannot rely on it
- Invariants (e.g., "balance is always ≥ 0") that are only informally understood and routinely violated in tests or edge cases
- Defensive checks scattered in callers rather than defined once at the contract boundary

## Good practice

```java
// Design by Contract with assertions (or a contract library)
public Money withdraw(Money amount) {
    // Precondition: caller's responsibility
    assert amount.isPositive() : "amount must be positive";
    assert amount.compareTo(balance) <= 0 : "insufficient funds";

    balance = balance.subtract(amount);

    // Postcondition: implementer's responsibility
    assert balance.isNonNegative() : "balance must not go negative after withdrawal";
    return amount;
}
```

- Document preconditions and postconditions in the method signature or contract annotation
- Use `assert`, a guard library (Guava Preconditions, .NET Code Contracts, Kotlin `require`/`check`), or property-based tests to verify contracts
- Respect the substitution rule: subclass preconditions must be no stronger than the parent's; postconditions must be no weaker
- Treat a violated precondition as a caller bug; treat a violated postcondition as an implementer bug

## Sources

- Meyer, Bertrand. *Object-Oriented Software Construction*, 2nd ed. Prentice Hall, 1997. ISBN 978-0-13-629155-8. Chapter 11, "Design by Contract."
