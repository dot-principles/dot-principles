# CODE-OB-STRUCTURED-TELEMETRY - Instrument code with structured, contextual telemetry

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Emit structured, machine-parseable telemetry with request-scoped context on every event.

## Principle

Emit telemetry that is structured (machine-parseable key-value pairs, not free-form strings) and contextual (carrying the request, user, and environment details necessary to understand what happened). Structured telemetry enables querying, filtering, and aggregation across arbitrary dimensions without writing custom parsers.

## Why it matters

Unstructured logs force engineers to grep through walls of text during incidents, wasting precious minutes. Structured telemetry lets teams slice data along any dimension - by customer, endpoint, region, or feature flag - turning observability data into an interactive debugging tool rather than a static record.

## Violations to detect

- Free-form log messages assembled with string concatenation instead of structured fields
- Log lines that lack context such as request ID, user ID, or service name
- Telemetry that omits machine-readable severity levels or event types
- Printf-style debug statements left in production code
- Inconsistent field names across services for the same concept (e.g., `userId` vs. `user_id` vs. `uid`)

## Good practice

- Use structured logging libraries that emit JSON or key-value formatted output
- Attach request-scoped context (trace ID, user ID, tenant) automatically via middleware or context propagation
- Define a shared schema for common fields across services
- Include enough context in each event to understand it without cross-referencing other events
- Treat instrumentation as a first-class concern during development, not an afterthought

## Sources

- Majors, Charity; Fong-Jones, Liz; Miranda, George. *Observability Engineering: Achieving Production Excellence*. O'Reilly, 2022. ISBN 978-1-492-07644-8.
