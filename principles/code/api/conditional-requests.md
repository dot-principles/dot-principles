# CODE-API-CONDITIONAL-REQUESTS - Support conditional requests for safe concurrent writes and cache revalidation

**Layer:** 2
**Categories:** api-design, reliability, rest
**Applies-to:** all
**Summary:** Require `If-Match` on concurrent writes and honour `If-None-Match` on GETs to prevent lost updates and wasted bandwidth.

## Principle

Resources that may be updated concurrently must support conditional write semantics using `ETag` / `If-Match`. A client reads a resource and receives its `ETag`; it includes `If-Match: <etag>` on any subsequent write. If the resource has changed since the read, the server returns 412 Precondition Failed instead of silently overwriting the concurrent change. GET endpoints should honour `If-None-Match` to return 304 Not Modified when the client's cached copy is still current, saving bandwidth.

## Why it matters

Without conditional requests, concurrent clients performing read-modify-write cycles silently overwrite each other's changes - the last writer always wins and earlier writes are lost with no error. This is a correctness hazard in any multi-user API. Conditional GETs also allow clients and caches to avoid re-downloading unchanged resources, directly reducing bandwidth and latency.

## Violations to detect

- PUT or PATCH endpoints that apply updates to concurrently editable resources without checking `If-Match`
- GET endpoints that return mutable resources without an `ETag` or `Last-Modified` header
- `If-None-Match` requests that receive a full 200 response instead of 304 when the ETag matches
- `If-Match` failures that return 200 (success) instead of 412 (precondition failed)
- `If-Match: *` not handled - this wildcard must succeed only if the resource exists

## Inspection

- `grep -rn "If-Match\|If-None-Match\|If-Modified-Since\|If-Unmodified-Since\|ETag" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Files handling conditional request headers (absence in PUT/PATCH handlers suggests missing concurrency protection)

## Good practice

- Return an `ETag` header on every GET response for mutable resources; the value should be a hash or version token that changes when the resource changes
- Require `If-Match` on PUT and PATCH for concurrently editable resources; return 412 if the condition fails
- Honour `If-None-Match` on GET to enable efficient cache revalidation; return 304 with no body if the ETag matches
- Use strong ETags (`"abc123"`) by default; weak ETags (`W/"abc123"`) are only appropriate for semantically equivalent but byte-different representations
- Document which resources require `If-Match` on write as part of the API contract

## Sources

- RFC 7232: "Hypertext Transfer Protocol (HTTP/1.1): Conditional Requests." IETF, 2014. https://www.rfc-editor.org/rfc/rfc7232
- RFC 9110: "HTTP Semantics." IETF, 2022. Section 13: "Conditional Requests." https://www.rfc-editor.org/rfc/rfc9110
