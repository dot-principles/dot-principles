# CODE-TP-BRANDED-TYPES - Use newtypes/branded types to prevent value confusion

**Layer:** 2
**Categories:** type-safety, correctness
**Applies-to:** all (especially typed languages)
**Summary:** Wrap primitive values in distinct types so the compiler rejects mismatched domain concepts at compile time.

## Principle

Wrap primitive values in distinct types to prevent accidentally passing one kind of value where another is expected. A customer ID and an order ID may both be integers, but they are not interchangeable. A temperature in Celsius and a temperature in Fahrenheit are both floats, but adding them is a bug. Newtypes (single-field wrappers), branded types, or opaque type aliases give the compiler the information it needs to catch these mix-ups at compile time, with zero or negligible runtime cost.

## Why it matters

Primitive obsession - using raw strings, integers, and floats for domain concepts - is one of the most common sources of subtle bugs. Function signatures like `createOrder(customerId: string, productId: string, couponCode: string)` invite transposition errors that no test will catch until the wrong customer gets the wrong order. When each concept has its own type, the compiler rejects `createOrder(productId, customerId, couponCode)` immediately. The Mars Climate Orbiter was lost because one module produced thrust in pound-force-seconds and another expected newton-seconds - both were floating-point numbers.

## Violations to detect

- Functions with multiple parameters of the same primitive type where transposition would be a silent bug (e.g., `transfer(fromAccount: string, toAccount: string, amount: number)`)
- Domain identifiers (user ID, order ID, product ID) all typed as `string` or `int` with no compile-time distinction
- Physical units (meters, seconds, kilograms, currencies) represented as bare numeric types with no unit information
- Email addresses, URLs, phone numbers, and other structured values typed as plain `string` throughout the codebase
- Implicit conversions between conceptually different values that happen to share a primitive representation

## Good practice

- Create newtype wrappers: `CustomerId(int)`, `OrderId(int)`, `EmailAddress(string)` - even if the wrapper is a single field
- In TypeScript, use branded types (`type CustomerId = string & { readonly __brand: 'CustomerId' }`) to get compile-time distinction without runtime overhead
- In Kotlin, use `value class` (inline classes) to wrap primitives with zero allocation overhead
- In Rust, use the newtype pattern (`struct CustomerId(u64)`) with the `Deref` trait only when implicit unwrapping is genuinely safe
- In Java, consider using records (`record CustomerId(long value) {}`) for lightweight wrappers
- Validate constraints at construction time (e.g., `EmailAddress.parse()` verifies format) so that the type itself guarantees validity

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1.
- Wlaschin, Scott. *Domain Modeling Made Functional*. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-254-1.
