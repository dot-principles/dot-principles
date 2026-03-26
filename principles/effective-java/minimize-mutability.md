# EFFECTIVE-JAVA-MINIMIZE-MUTABILITY — Minimize Mutability — Prefer Immutable Classes

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Make classes immutable by default: prevent extension, make fields final, and return new instances from operations.

## Principle

An immutable class is one whose instances cannot be modified after creation. All the information in each instance is fixed for the lifetime of the object. To make a class immutable: do not provide mutator methods, ensure the class cannot be extended, make all fields final and private, ensure exclusive access to any mutable components, and return new instances from operations rather than modifying existing ones.

## Why it matters

Immutable objects are inherently thread-safe — they require no synchronization. They can be shared freely, cached, and used as map keys or set elements without risk. They make reasoning about program state far simpler because an immutable object's state is the same at every point after construction.

## Violations to detect

- Value classes with setter methods that could instead be immutable
- Mutable fields in classes that are shared across threads without synchronization
- Public mutable fields or methods that return references to mutable internal state without defensive copies
- Classes that could be `final` but are left open for subclassing without a clear extension use case

## Good practice

```java
// Violation — mutable Money class
class Money {
    private BigDecimal amount;
    public void setAmount(BigDecimal a) { this.amount = a; }  // mutable
}

// Correct — immutable Money; operations return new instances
public final class Money {
    private final BigDecimal amount;
    private final Currency currency;
    public Money(BigDecimal amount, Currency currency) {
        this.amount = amount; this.currency = currency;
    }
    public Money add(Money other) {
        return new Money(this.amount.add(other.amount), this.currency);
    }
}
```

- Make fields `private` and `final`; do not provide setters
- Make the class `final` or give it only `private` constructors with static factory methods
- Return defensive copies of any mutable internal components from accessors
- If mutability is required for performance, provide a mutable companion class (e.g., `StringBuilder` for `String`)

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 17: "Minimize mutability."
