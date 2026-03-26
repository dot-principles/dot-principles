# EIP-CORRELATION-IDENTIFIER — Correlation Identifier

**Layer:** 2 (contextual)
**Categories:** integration, observability, messaging
**Applies-to:** all
**Summary:** Attach and propagate a unique Correlation Identifier through every message, downstream call, log, and trace span.

## Principle

Attach a unique Correlation Identifier to every message — request and reply alike — so that any message can be matched to the request that initiated it and to other messages in the same logical flow. The ID must be propagated through every downstream call and included in all log entries and trace spans.

## Why it matters

In asynchronous and distributed systems, operations span multiple messages, services, and time boundaries. Without a correlation ID, it is impossible to reconstruct which reply matches which request, which downstream calls were triggered by which originating event, or why a failure occurred. Correlation IDs are the connective tissue that makes distributed traces possible.

## Violations to detect

- Asynchronous reply messages that contain no identifier linking them back to the request
- Service calls that do not forward the incoming correlation ID to downstream services, breaking the trace chain
- Log entries for operations that contain no correlation ID, making it impossible to aggregate all log lines for a single business operation
- Code that generates a new correlation ID on each internal call rather than propagating the one received

## Good practice

- Generate a UUID correlation ID at the system entry point (HTTP gateway, message consumer) if none is present
- Propagate it in every outbound call — HTTP headers (`X-Correlation-ID`, W3C `traceparent`), message metadata, queue message attributes
- Log it alongside every log entry for the operation
- Verify propagation with integration tests that assert the ID appears in downstream service logs

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Chapter 8, "Correlation Identifier."
