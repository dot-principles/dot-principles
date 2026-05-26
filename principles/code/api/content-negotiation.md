# CODE-API-CONTENT-NEGOTIATION - Honour the Accept header and respond with the negotiated content type

**Layer:** 2
**Categories:** api-design, rest, interoperability
**Applies-to:** all
**Summary:** Inspect the `Accept` header and respond with the negotiated media type, returning 406 if none is supported.

## Principle

APIs must inspect the client's `Accept` header and respond with a representation in one of the requested media types. If no supported type can be produced, return 406 Not Acceptable with a body listing supported types. Always set a precise `Content-Type` header on the response. When the client sends `Accept: */*` or no `Accept` header, respond with the server's default type and set `Content-Type` explicitly. Do not hardcode a single content type into all endpoints.

## Why it matters

Hardcoding `application/json` prevents the API from serving clients with different requirements (a browser wanting HTML, a mobile app wanting JSON, a legacy system needing XML). It also leaks representation decisions into client code, tightly coupling clients to the server's current choice. Content negotiation is a built-in HTTP mechanism for decoupling clients from representation details without changing the API surface.

## Violations to detect

- Endpoints that always respond with `application/json` regardless of the client's `Accept` header
- Missing or incorrect `Content-Type` header on responses
- No handling for `Accept: */*` - the server must select its default type and declare it in `Content-Type`
- Returning 500 or 400 instead of 406 when the client requests an unsupported media type
- Request bodies parsed without checking `Content-Type`, silently accepting arbitrary or malformed formats

## Inspection

- `grep -rn "application/json\|MediaType\.APPLICATION_JSON\|produces.*json\|consumes.*json\|content_type.*json" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | LOW | Files hardcoding JSON media type (review whether Accept-header negotiation is also supported)

## Good practice

- Parse the `Accept` header and select the best match using q-value weighted preference
- Default to `application/json` when the client sends `Accept: */*` or omits the header; always set the `Content-Type` response header explicitly
- Return 406 Not Acceptable with a list of supported media types when no match is possible
- Support `application/problem+json` for error responses alongside the normal content types (see RFC 7807)
- Declare supported request and response media types per endpoint in the OpenAPI specification

## Sources

- RFC 7231: "HTTP/1.1 Semantics and Content." IETF, 2014. Section 3.4: "Content Negotiation." https://www.rfc-editor.org/rfc/rfc7231
- RFC 9110: "HTTP Semantics." IETF, 2022. Section 12: "Content Negotiation." https://www.rfc-editor.org/rfc/rfc9110
