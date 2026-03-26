# CODE-API-HTTP-CACHING — Set Cache-Control and validation headers on cacheable responses

**Layer:** 2
**Categories:** api-design, performance, rest
**Applies-to:** all
**Summary:** Set explicit `Cache-Control` and validation headers on every GET response; never rely on intermediary defaults.

## Principle

Every GET response must carry explicit `Cache-Control` directives that communicate whether and for how long the response may be cached. Cacheable resources should also include `ETag` or `Last-Modified` headers to support conditional revalidation. Private or sensitive resources must be explicitly marked `Cache-Control: no-store`. Never rely on default caching behaviour in intermediaries — always be explicit.

## Why it matters

Caching is the primary mechanism for reducing latency and origin load in HTTP systems. Clients, CDNs, and reverse proxies all make caching decisions based on `Cache-Control`. Omitting these headers hands the decision to each intermediary's defaults, which vary widely — some will cache everything (including private data), others nothing (wasting bandwidth). Incorrect caching can serve stale data, expose private information through shared caches, or re-fetch unchanged resources on every request.

## Violations to detect

- GET endpoints that return responses with no `Cache-Control` header
- Sensitive or personalised responses (user profiles, account data) without `Cache-Control: private` or `no-store`
- Cacheable resources with no `ETag` or `Last-Modified` header, preventing efficient revalidation
- POST, PUT, PATCH, or DELETE responses carrying a `Cache-Control` header that permits caching
- Overly long `max-age` values (days or weeks) on resources that change frequently

## Inspection

- `grep -rn "Cache-Control\|ETag\|Last-Modified\|Expires" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Files setting cache headers (absence in GET handler files suggests missing caching directives)

## Good practice

- Rarely-changing public resources: `Cache-Control: public, max-age=3600, stale-while-revalidate=60`
- Private user-specific data: `Cache-Control: private, no-store`
- Real-time or highly dynamic data: `Cache-Control: no-cache, no-store`
- Include `ETag` (a hash or version of the response body) on all cacheable resources to enable `304 Not Modified` responses and avoid re-transmitting unchanged data
- Use `Vary: Accept-Encoding, Accept` when responses differ by negotiated content type or encoding

## Sources

- RFC 9111: "HTTP Caching." IETF, 2022. https://www.rfc-editor.org/rfc/rfc9111
- RFC 7234: "HTTP/1.1: Caching." IETF, 2014. https://www.rfc-editor.org/rfc/rfc7234 (superseded by RFC 9111)
