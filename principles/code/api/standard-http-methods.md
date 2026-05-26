# CODE-API-STANDARD-HTTP-METHODS - Use standard HTTP methods with their defined semantics

**Layer:** 2
**Categories:** api-design, rest, protocol-design
**Applies-to:** all
**Summary:** Honor HTTP method semantics - GET must be safe, PUT and DELETE must be idempotent.

## Principle

Each HTTP method carries a defined contract: GET is safe (no side effects), PUT is idempotent (repeating it produces the same result), DELETE is idempotent, and POST is neither safe nor idempotent. APIs must honor these method semantics so that clients, caches, proxies, and intermediaries can rely on the guarantees the protocol provides. Violating method semantics - such as using GET to modify state - breaks the architectural properties that REST depends on.

## Why it matters

The uniform interface constraint is what makes the web scalable. Intermediaries (caches, CDNs, load balancers) make decisions based on method semantics - caches can safely replay GET requests, and clients can safely retry PUT requests after a network failure. When an API misuses methods, these assumptions break, leading to data corruption, cache poisoning, and unreliable behavior under failure conditions.

## Violations to detect

- GET endpoints that create, update, or delete resources (side effects on safe methods)
- PUT endpoints that are not idempotent - calling them twice produces different results
- POST used where PUT or PATCH would be semantically correct (e.g., full resource replacement)
- DELETE endpoints that return different results on repeated calls rather than being idempotent
- PATCH requests that send a full resource representation instead of a partial update

## Good practice

- Use GET exclusively for retrieval - never modify server state on a GET request
- Use PUT for full resource replacement and ensure it is idempotent - the same PUT with the same body always produces the same resource state
- Use POST for creating resources when the server assigns the identifier, or for operations that are inherently non-idempotent
- Use DELETE for resource removal and make it idempotent - deleting an already-deleted resource returns 404 or 204, not an error
- Use PATCH for partial updates, and document whether your PATCH implementation is idempotent

## Sources

- Fielding, Roy. "Architectural Styles and the Design of Network-based Software Architectures." PhD dissertation, University of California, Irvine, 2000. Chapter 5: "Representational State Transfer (REST)."
- RFC 9110: "HTTP Semantics." IETF, 2022. Sections 9.2-9.3 (method properties: safe, idempotent). https://www.rfc-editor.org/rfc/rfc9110
