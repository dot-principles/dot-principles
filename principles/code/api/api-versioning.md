# CODE-API-VERSIONING - Version APIs explicitly and define a policy for breaking changes

**Layer:** 2
**Categories:** api-design, backward-compatibility, rest
**Applies-to:** all
**Summary:** Version every API explicitly and maintain old versions through a documented deprecation period before removal.

## Principle

Every API that has external consumers must carry an explicit version identifier. When a breaking change is unavoidable, introduce a new version rather than modifying the existing one, and maintain the old version for a documented deprecation period. Additive changes (new optional fields, new endpoints) do not require a new version. The versioning scheme and deprecation policy must be documented and communicated to consumers before a breaking change is deployed.

## Why it matters

Without explicit versioning, any breaking change forces all consumers to update simultaneously or break. APIs that lack a versioning strategy accumulate unspoken compatibility debt - maintainers either freeze the API forever or break consumers without warning. A clear versioning policy gives consumers a predictable window to migrate and gives maintainers the freedom to evolve the API without holding it hostage to the slowest consumer.

## Violations to detect

- Public or shared API endpoints with no version identifier in the URI, header, or media type
- Breaking changes deployed to an existing version without introducing a new version (removing fields, changing types, making optional params required)
- No documented deprecation policy - no timeline, no migration guide, no sunset header on deprecated endpoints
- Deprecated endpoints missing `Deprecation` or `Sunset` response headers
- Multiple incompatible versioning strategies mixed in the same API (URI versioning on some endpoints, header versioning on others)

## Inspection

- `grep -rn "v1\|v2\|v3\|/api/" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | LOW | Files referencing versioned API paths (review for consistency of versioning strategy)
- `grep -rn "Deprecation\|Sunset\|deprecated" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Files marking endpoints as deprecated (absence may indicate missing deprecation signalling)

## Good practice

- Use URI path versioning (`/v1/orders`) as the default - it is visible, cacheable, and unambiguous; use content-type versioning (`Accept: application/vnd.api+json;version=2`) only when the API contract demands it
- Define a deprecation policy before publishing v1: minimum notice period, support overlap window, migration documentation
- Set `Deprecation: true` and `Sunset: <HTTP-date>` headers on deprecated endpoints so clients can detect and automate migration alerts
- Treat additive changes (new optional fields, new endpoints, new optional query parameters) as non-breaking - these do not require a new version
- Keep the number of simultaneously supported versions small (typically two: current and previous)

## Sources

- Fielding, Roy T. "Architectural Styles and the Design of Network-based Software Architectures." PhD dissertation, UC Irvine, 2000.
- Richardson, Leonard; Ruby, Sam. *RESTful Web Services*. O'Reilly, 2007. ISBN 978-0-596-52926-0.
- RFC 8594: "The Sunset HTTP Header Field." IETF, 2019. https://www.rfc-editor.org/rfc/rfc8594
- IETF Draft: "The Deprecation HTTP Header Field." https://datatracker.ietf.org/doc/draft-ietf-httpapi-deprecation-header/
