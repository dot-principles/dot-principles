# EIP-AGGREGATOR - Aggregator

**Layer:** 2 (contextual)
**Categories:** integration, messaging, reliability
**Applies-to:** all
**Summary:** Always define a correlation expression, completeness condition, and timeout strategy for every Aggregator.

## Principle

An Aggregator collects and combines a sequence of related messages into a single composite message. It requires three things to work correctly: a correlation expression that groups incoming messages into the right bucket, a completeness condition that determines when enough messages have arrived to produce the output, and a timeout or discard strategy for incomplete groups that never finish. These three elements must all be explicit - none can be left implicit or absent.

## Why it matters

Without explicit correlation, completeness, and timeout, aggregation drifts into an unbounded memory accumulation that grows silently until the process crashes or degrades. Incomplete groups that never time out prevent downstream processing and hide missing messages. Aggregation state that lives only in application memory is lost on restart, causing partial results to be silently dropped. The Aggregator pattern forces these concerns to be addressed explicitly and in one place.

## Violations to detect

- An in-memory `Map` or `List` that accumulates messages keyed by correlation ID with no expiry, TTL, or bounded size - unbounded state that grows until OOM
- No explicit completion condition: the aggregator either waits forever or produces output on an arbitrary first-N-messages-arrived heuristic with no documentation
- Aggregation state stored in a local variable or non-persistent structure that is lost on service restart or crash
- Aggregation logic spread across multiple consumers each maintaining their own partial accumulation of the same logical group
- No handling of out-of-order or late-arriving messages - the aggregator silently drops messages that arrive after the group was closed

## Good practice

- Use a messaging framework's built-in aggregator (Spring Integration `@Aggregator`, Apache Camel `aggregate()`, Kafka Streams `reduce`) rather than hand-rolling accumulation
- Make the correlation expression, completion condition, and timeout all explicit and documented in the code
- Persist aggregation state to a durable store (database, Redis) so that incomplete groups survive restarts
- Configure a discard strategy for timed-out groups: route to a dead-letter channel, emit a partial result with a flag, or raise an alert
- Emit a metric on group completion time and size to detect abnormal aggregation behaviour in production

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Aggregator."
- Hohpe, Gregor & Woolf, Bobby. "Aggregator." https://www.enterpriseintegrationpatterns.com/patterns/messaging/Aggregator.html (accessed 2026-03-22).
