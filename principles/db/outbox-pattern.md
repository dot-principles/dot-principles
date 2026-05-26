# DB-OUTBOX-PATTERN - Outbox pattern - write events transactionally with domain changes to avoid dual-write

**Layer:** 2
**Categories:** database, reliability, distributed-systems, messaging
**Applies-to:** distributed-systems, microservices, event-driven
**Summary:** Write events to an outbox table in the same transaction as domain changes to eliminate dual-write failures.

## Principle

When a service must both persist a domain change and publish an event or message, write the event to an outbox table in the same local database transaction as the domain change. A separate relay process then reads uncommitted outbox rows and publishes them to the message broker, deleting or marking them after successful delivery. This pattern eliminates the dual-write problem: it is impossible to persist the domain change without also recording the event, and vice versa.

## Why it matters

The naive approach - write to the database, then publish to a message broker - has a window of failure between the two operations. If the process crashes after the database write but before the broker publish, the downstream consumer never receives the event. The dual-write problem produces subtle, hard-to-detect inconsistencies: the database says one thing, the event stream says another, and the two silently diverge.

## Violations to detect

- Calling a message broker publish method directly inside a service method after a database save, with no transactional coordination between the two
- Catching message broker publish failures and logging them as warnings rather than treating them as blocking errors - the system continues with an unpublished event
- Attempting to solve dual-write with a distributed transaction (XA/2PC) between the database and broker - high complexity and low availability compared to the outbox
- Outbox relay processes that mark events as processed before confirming broker acknowledgement - creates the same loss window in reverse

## Good practice

- Add an `outbox` (or `events`) table to the service's own database; insert event records in the same transaction as the domain write
- Use a relay (Debezium, a polling loop, or a database trigger) to read unprocessed outbox rows and publish them to the broker with at-least-once delivery
- Make consumers idempotent so that duplicate delivery from the relay is harmless
- Clean up processed outbox rows periodically to prevent unbounded table growth; keep a configurable retention window for debugging

## Sources

- Richardson, Chris. *Microservices Patterns: With Examples in Java*. Manning, 2018. ISBN 978-1-617-29454-9. Chapter 3: "Managing transactions with sagas." (Transactional Outbox pattern)
- Richardson, Chris. "Pattern: Transactional outbox." microservices.io. https://microservices.io/patterns/data/transactional-outbox.html (accessed 2026-03-16).
