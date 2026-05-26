# EIP-WIRE-TAP - Wire Tap

**Layer:** 2 (contextual)
**Categories:** integration, messaging, observability
**Applies-to:** all
**Summary:** Insert a Wire Tap to forward message copies to a secondary channel without affecting the primary flow.

## Principle

A Wire Tap inserts a passive monitoring point into a message channel that forwards a copy of every message to a secondary inspection channel - for logging, auditing, testing, or debugging - without modifying the original message or affecting the primary message flow. The Wire Tap must be transparent: the primary consumer must receive the original message at the same time and with the same content as if the Wire Tap were not present. Any failure in the secondary channel must not propagate back to the primary flow.

## Why it matters

Without a proper Wire Tap, teams resort to instrumenting consumers and processors directly - adding log statements, capturing payloads in variables, or forwarding messages inside handler code. This approach entangles monitoring with processing, risks modifying the message before it reaches the consumer, and means monitoring failures can cause consumer failures. A Wire Tap decouples observation from processing: the primary flow is unaware of monitoring, and monitoring is independently deployable and removable.

## Violations to detect

- Logging or inspection code inside a message consumer that reads and potentially transforms the message payload before the consumer sees it
- A monitoring interceptor that calls an external service synchronously as part of message processing - if the monitoring service is slow or down, message delivery is affected
- Debug or tracing code that was added temporarily during an incident and never removed, emitting sensitive message content to application logs
- A "Wire Tap" that acknowledges or commits the original message before the primary consumer processes it - can cause silent message loss if the consumer subsequently fails

## Good practice

- Implement the Wire Tap as a dedicated pipeline stage that publishes a copy of the message to a secondary channel before passing the original to the primary consumer unchanged
- Use fire-and-forget or best-effort semantics for the secondary channel - failures in the monitoring channel must not raise exceptions in the primary flow
- Remove temporary Wire Taps introduced for debugging once the debugging session is complete; treat them as infrastructure changes requiring a code review
- Use framework-native interceptors (Spring Integration `WireTap`, Apache Camel intercept/`wireTap()`) that enforce the transparency guarantee rather than hand-rolling inspection logic

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Wire Tap."
- Hohpe, Gregor & Woolf, Bobby. "Wire Tap." https://www.enterpriseintegrationpatterns.com/patterns/messaging/WireTap.html (accessed 2026-03-22).
