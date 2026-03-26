# CODE-API-RATE-LIMITING — Enforce rate limits and signal capacity constraints with standard headers

**Layer:** 2
**Categories:** api-design, reliability, security
**Applies-to:** all
**Summary:** Enforce rate limits on all APIs and return 429 with `Retry-After` when clients exceed their quota.

## Principle

APIs must enforce rate limits to protect backend capacity and maintain availability under load. When a client exceeds a limit, respond with HTTP 429 Too Many Requests and a `Retry-After` header indicating when the client may retry. Advertise current quota state in response headers (`RateLimit-Limit`, `RateLimit-Remaining`, `RateLimit-Reset`) so clients can self-throttle before hitting the limit.

## Why it matters

An API without rate limiting is vulnerable to accidental overload from misbehaving clients and to deliberate abuse. A single runaway consumer can degrade or bring down the service for everyone. Standard headers allow well-behaved clients to pace themselves, reducing retries and dropped requests, and give operators observable metrics for capacity planning.

## Violations to detect

- API endpoints accessible without any rate-limiting middleware or filter in the request pipeline
- 429 responses that omit the `Retry-After` header
- Rate limit errors returned as 500 or 400 instead of 429
- No `RateLimit-*` or `X-RateLimit-*` headers on responses, leaving clients unable to self-throttle
- Inconsistent limits applied to the same resource through misconfigured middleware

## Inspection

- `grep -rn "429\|TOO_MANY_REQUESTS\|RateLimitException\|rateLimiter\|rate_limit\|throttl" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Files referencing rate limiting (absence in handler files suggests no enforcement)
- `grep -rn "Retry-After\|RateLimit-Limit\|RateLimit-Remaining\|X-RateLimit" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Files setting rate-limit response headers (absence suggests missing client guidance)

## Good practice

- Apply rate limiting as middleware at the API gateway or framework filter level — not ad hoc per endpoint
- Return `Retry-After: <seconds>` or `Retry-After: <HTTP-date>` alongside every 429 response
- Expose quota headers on every response so clients can adjust before hitting the ceiling:
  - `RateLimit-Limit: 100` — requests allowed per window
  - `RateLimit-Remaining: 42` — requests left in the current window
  - `RateLimit-Reset: 1711234567` — epoch seconds when the window resets
- Distinguish user-level, application-level, and IP-level limits; include which limit was exceeded in the 429 body
- Document rate limit policies in the API reference so clients can design around them

## Sources

- RFC 6585: "Additional HTTP Status Codes." IETF, 2012. Section 4: "429 Too Many Requests." https://www.rfc-editor.org/rfc/rfc6585
- IETF Draft: "RateLimit Header Fields for HTTP." https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/
