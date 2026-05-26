# CODE-API-PROBLEM-DETAILS - Return structured error responses using the RFC 7807 Problem Details format

**Layer:** 2
**Categories:** api-design, developer-experience, rest
**Applies-to:** all
**Summary:** Return RFC 7807 Problem Details for all error responses; never expose stack traces or internal details.

## Principle

Error responses must be machine-readable and consistent. Use the RFC 7807 Problem Details format: a JSON object with `type` (a URI identifying the error class), `title` (a short human-readable summary), `status` (the HTTP status code), `detail` (a specific explanation for this occurrence), and optionally `instance` (a URI identifying this specific error occurrence). Set `Content-Type: application/problem+json`. Never expose stack traces, internal exception class names, or database error messages in error responses.

## Why it matters

Inconsistent error formats force API consumers to write custom parsing logic for every error shape across every endpoint. A standard format lets clients handle all errors with a single code path and lets monitoring tools parse and categorise errors automatically. Exposing internal details (exception types, SQL errors, stack traces) also leaks information that aids attackers.

## Violations to detect

- Error responses using `application/json` (not `application/problem+json`) with ad-hoc fields (`message`, `error`, `errorCode`) instead of `type`/`title`/`status`/`detail`
- Stack traces, exception class names (`NullPointerException`, `SqlException`), or internal identifiers exposed in error response bodies
- Inconsistent error shapes across endpoints (some return `{"error": "..."}`, others `{"message": "..."}`)
- 4xx and 5xx responses with an empty body or an HTML error page
- Missing `status` field in the error body, requiring clients to parse the HTTP header separately

## Good practice

- Return `Content-Type: application/problem+json` for all error responses
- Minimum required fields: `type`, `title`, `status`, `detail`
- Use a stable, documented URI as `type` - it should identify the class of error, not the specific instance
- Extend with custom members for domain context (e.g., `invalid-params` array for validation errors per RFC 9457)
- Handle all unhandled exceptions in a global error handler that maps them to a Problem Details response
- Log the `instance` URI server-side to correlate client-reported errors with server traces

## Sources

- RFC 7807: "Problem Details for HTTP APIs." IETF, 2016. https://www.rfc-editor.org/rfc/rfc7807
- RFC 9457: "Problem Details for HTTP APIs." IETF, 2023 (updates RFC 7807). https://www.rfc-editor.org/rfc/rfc9457
