# CODE-API-HTTP-STATUS-CODES — Use proper HTTP status codes to communicate outcomes

**Layer:** 2
**Categories:** api-design, rest, protocol-design
**Applies-to:** all
**Summary:** Use HTTP status codes precisely to communicate outcomes; never return 200 for errors.

## Principle

HTTP status codes are a fundamental part of the uniform interface. APIs must use them correctly to communicate the outcome of a request: 2xx for success, 3xx for redirection, 4xx for client errors, and 5xx for server errors. Each specific code carries precise semantics — 201 means a resource was created, 404 means the resource was not found, 409 means a conflict. Returning 200 for everything and embedding the real status in the response body defeats the purpose of the protocol.

## Why it matters

Clients, proxies, caches, monitoring tools, and load balancers all interpret status codes to make decisions. A cache will store a 200 response but not a 500. A client retry library will retry a 503 but not a 400. Monitoring dashboards flag 5xx spikes as incidents. When an API returns 200 for errors, all of this infrastructure stops working correctly, and clients must parse response bodies to determine what actually happened — losing the benefits of the standardized protocol.

## Violations to detect

- Returning 200 OK for error conditions, with the actual error buried in the response body
- Using 500 Internal Server Error for client mistakes (e.g., validation failures that should be 400 or 422)
- Returning 404 for authorization failures that should be 403 (or 401)
- Using 400 Bad Request as a catch-all for every client error instead of more specific codes (409 Conflict, 422 Unprocessable Content, 429 Too Many Requests)
- Never returning 201 Created for successful resource creation (always using 200 instead)

## Good practice

- Use 200 OK for successful retrieval and general success, 201 Created when a new resource is created, and 204 No Content for successful operations with no response body
- Use 400 Bad Request for malformed syntax, 401 Unauthorized for missing/invalid authentication, 403 Forbidden for insufficient permissions, 404 Not Found for nonexistent resources, and 409 Conflict for state conflicts
- Use 500 Internal Server Error only for genuine unexpected server failures — never for input validation or business rule violations
- Include a structured error body with a machine-readable error code, a human-readable message, and (where applicable) a pointer to the offending field
- Document which status codes each endpoint may return

## Sources

- RFC 9110: "HTTP Semantics." IETF, 2022. Section 15: "Status Codes." https://www.rfc-editor.org/rfc/rfc9110
- Fielding, Roy. "Architectural Styles and the Design of Network-based Software Architectures." PhD dissertation, University of California, Irvine, 2000. Chapter 5.
