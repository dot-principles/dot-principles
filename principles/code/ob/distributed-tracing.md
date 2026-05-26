# CODE-OB-DISTRIBUTED-TRACING - Trace requests across service boundaries with correlation IDs

**Layer:** 2 (contextual)
**Categories:** observability, operations, reliability
**Applies-to:** all
**Summary:** Assign a unique trace ID at every request entry point and propagate it through all services.

## Principle

Assign a unique trace or correlation ID at the entry point of every request and propagate it through every service, queue, and data store the request touches. Distributed tracing connects the fragments of a request's journey into a coherent story, making it possible to understand latency, identify bottlenecks, and diagnose failures that span multiple services.

## Why it matters

In distributed systems, a single user action may traverse dozens of services. Without a correlation ID linking these interactions, diagnosing a slow or failed request requires guessing which log entries across which services belong together. Distributed tracing transforms an impossible search into a single query.

## Violations to detect

- Services that generate new request IDs internally without propagating the upstream trace ID
- HTTP calls or message queue publications that do not forward trace context headers
- Log entries in downstream services that lack the originating trace or correlation ID
- Services that silently drop tracing headers during request processing
- Asynchronous workers or background jobs that lose the trace context from the originating request

## Good practice

- Generate a trace ID at the system's edge (API gateway, load balancer, or first service) and propagate it via standard headers (e.g., W3C Trace Context `traceparent`)
- Use OpenTelemetry or an equivalent framework to automate context propagation across HTTP, gRPC, and messaging boundaries
- Include the trace ID in all log entries, metrics, and events emitted during request processing
- Ensure asynchronous handoffs (queues, scheduled jobs) carry and restore trace context

## Sources

- Majors, Charity; Fong-Jones, Liz; Miranda, George. *Observability Engineering: Achieving Production Excellence*. O'Reilly, 2022. ISBN 978-1-492-07644-8.
