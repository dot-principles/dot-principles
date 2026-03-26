# CODE-API-BACKWARD-COMPATIBILITY — Support backward compatibility — never break existing clients

**Layer:** 2
**Categories:** api-design, rest, protocol-design
**Applies-to:** all
**Summary:** Only add to published APIs; never remove, rename, or change fields without introducing a new version.

## Principle

Once an API is published and clients depend on it, changes must be backward compatible. Adding new fields, endpoints, or optional parameters is safe; removing fields, renaming parameters, changing the type of a return value, or altering the meaning of existing behavior is not. When a breaking change is unavoidable, introduce a new version of the API and maintain the old version for a documented deprecation period.

## Why it matters

APIs are shared contracts. Unlike internal code, you do not control who calls your API or when they update. A breaking change that seems minor — removing an unused field, changing a date format — can cause silent data loss or outright failures in client applications you have never seen. The cost of a breaking change is multiplied by the number of clients and the difficulty of coordinating their updates.

## Violations to detect

- Removing or renaming fields in response bodies without versioning
- Changing the type of an existing field (e.g., string to integer, single value to array)
- Making a previously optional request parameter required
- Changing the meaning or behavior of an existing endpoint without a version bump
- Removing or renaming endpoints that clients may depend on
- Altering error response formats or status codes for existing error conditions

## Good practice

- Treat published API fields and endpoints as immutable contracts — add, never remove or rename
- Use additive changes: new optional fields, new endpoints, new optional query parameters
- When breaking changes are necessary, use explicit versioning (URI path versioning like `/v2/`, or content-type versioning via `Accept` headers)
- Provide a deprecation policy: announce deprecation, give clients a migration window, and document the replacement
- Use contract testing (consumer-driven contracts) to detect accidental breaking changes before release

## Sources

- Bloch, Joshua. "How to Design a Good API and Why It Matters." OOPSLA 2006 companion, ACM, 2006.
- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1.
