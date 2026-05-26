# GOF-LAW-OF-DEMETER - Law of Demeter (Principle of Least Knowledge)

**Layer:** 1 (universal)
**Categories:** software-design, object-oriented, coupling
**Applies-to:** all
**Summary:** Call methods only on direct collaborators; never chain through objects returned by other calls.

## Principle

A method should only call methods on: (1) the object itself (`this`), (2) objects passed in as parameters, (3) objects it creates or instantiates locally, and (4) the object's direct component fields. It should never call a method on an object *returned* by another call - "don't talk to strangers." Each unit of code should have only limited knowledge about other units.

## Why it matters

Long method chains (`a.getB().getC().doSomething()`) couple a caller to the internal structure of objects it has no business knowing about. If `B` or `C`'s structure changes, the caller breaks even though it has no direct relationship with those types. Violations produce fragile, tightly coupled code where changes ripple unexpectedly across the codebase.

## Violations to detect

- Method chains two or more levels deep: `object.getX().getY().doZ()`
- Code that navigates an object graph to retrieve a deeply nested field instead of asking the root object to provide the needed value
- A method that calls a getter on an object only to call another getter on the result
- Classes that import types they only encounter through getter chains, not through direct dependencies

## Inspection

- `grep -rnE '\.[a-zA-Z]+\(\)\.[a-zA-Z]+\(\)\.' --include="*.java" --include="*.ts" --include="*.js" --include="*.cs" $TARGET` | MEDIUM | Method chains three or more levels deep (possible LoD violation - verify context)

## Good practice

Introduce a method on the intermediate object that provides what the caller needs, rather than exposing the chain.

```java
// Violation - caller knows about Order's internal Payment structure
String cardNumber = order.getPayment().getCreditCard().getNumber();

// Correct - Order exposes only what callers need
String cardNumber = order.getPaymentCardNumber();
```

- If you need something from a deeply nested object, add a method to the intermediate object that provides it
- Ask "does this class really need to know about the type it receives from that getter?" - if not, push the behaviour inward
- Law of Demeter often surfaces Feature Envy; move the behaviour to where the data lives

## Sources

- Lieberherr, Karl J., and Ian Holland. "Assuring good style for object-oriented programs." *IEEE Software*, 6(5), 1989, pp. 38-48. DOI: 10.1109/52.35588
- Hunt, Andrew, and David Thomas. *The Pragmatic Programmer: From Journeyman to Master*. Addison-Wesley, 1999. ISBN 978-0-201-61622-4. Tip 36 "Minimize Coupling Between Modules."
