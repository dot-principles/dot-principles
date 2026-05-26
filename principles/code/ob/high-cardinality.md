# CODE-OB-HIGH-CARDINALITY - Use high-cardinality fields for debugging in production

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Include high-cardinality fields like user IDs in telemetry to pinpoint exactly who and what is affected.

## Principle

Include high-cardinality fields - such as user IDs, request IDs, shopping cart IDs, or specific parameter values - in your telemetry. High-cardinality dimensions let you identify the specific user, request, or entity experiencing a problem, rather than only knowing that "something is wrong somewhere." Traditional metrics systems discard this detail through aggregation; observability requires preserving it.

## Why it matters

Production issues rarely affect all users equally. A problem might affect only one customer, one region, or one specific input. Without high-cardinality fields, engineers can see that error rates increased but cannot determine who is affected or why. High-cardinality data turns a vague alert into an actionable diagnosis.

## Violations to detect

- Telemetry that only includes low-cardinality fields (HTTP method, status code, service name) without request-specific identifiers
- Metrics pipelines that strip unique identifiers before storage to reduce cardinality costs
- Instrumentation that aggregates values before emission, losing the ability to inspect individual events
- Log messages that describe errors without identifying the affected entity (e.g., "request failed" with no request ID)

## Good practice

- Include user ID, request ID, session ID, and relevant entity IDs in every telemetry event
- Use an observability backend that supports high-cardinality fields without prohibitive cost
- Attach business-relevant identifiers (order ID, transaction ID) alongside technical identifiers
- Design schemas that allow breaking down any metric by arbitrary field combinations after the fact

## Sources

- Majors, Charity; Fong-Jones, Liz; Miranda, George. *Observability Engineering: Achieving Production Excellence*. O'Reilly, 2022. ISBN 978-1-492-07644-8.
