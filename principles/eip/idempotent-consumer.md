# EIP-IDEMPOTENT-CONSUMER — Idempotent Consumer

**Layer:** 2 (contextual)
**Categories:** integration, messaging, reliability
**Applies-to:** all
**Summary:** Track processed message IDs and discard duplicates to achieve effectively-once processing under at-least-once delivery.

## Principle

An Idempotent Consumer detects and safely discards duplicate message deliveries by maintaining a store of processed message IDs. Since most messaging systems guarantee at-least-once delivery — not exactly-once — any consumer may receive the same message more than once due to broker retries, consumer crashes after processing but before acknowledgement, or network failures. The Idempotent Consumer checks an incoming message's ID against the store before processing: if the ID is already present, the message is a duplicate and is acknowledged without reprocessing.

**See also:** `CODE-RL-IDEMPOTENCY` covers the general principle of designing operations to be safely retryable. This pattern focuses specifically on the message-consumer implementation: the dedup store mechanism that enables at-least-once consumers to achieve effectively-once processing behaviour.

## Why it matters

At-least-once delivery is the default guarantee in Kafka, RabbitMQ, SQS, and virtually every production messaging system. A consumer that does not detect duplicates will double-process orders, double-charge customers, or emit duplicate events downstream whenever the broker redelivers a message. The dedup store is the only mechanism that makes at-least-once delivery behave like exactly-once processing from the application's perspective.

## Violations to detect

- A message consumer that processes every incoming message unconditionally with no check of a previously-seen-IDs store
- Message payloads or headers that carry no unique message ID — without an ID, deduplication is impossible at the consumer
- A dedup store with no TTL, eviction policy, or maximum size — grows without bound, eventually exhausting storage
- Inconsistent dedup coverage: some code paths in the consumer check for duplicates but others do not, leaving gaps under certain conditions
- Dedup state held in an in-process data structure only — lost on restart, making the consumer vulnerable to duplicates after a crash

## Good practice

- Assign a globally unique, stable message ID at the producer (UUID, content hash, or business key) and include it in every message
- Before processing, check the message ID against a durable dedup store (Redis, database unique index); if present, acknowledge and skip without processing
- Record the message ID in the dedup store atomically with the business effect, or use an outbox pattern to ensure both happen together
- Configure a TTL on dedup store entries matching the maximum expected message redelivery window — entries older than the retention window can be safely expired
- Test duplicate handling explicitly: deliver the same message twice in integration tests and assert the business effect is applied exactly once

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Idempotent Receiver."
- Hohpe, Gregor & Woolf, Bobby. "Idempotent Receiver." https://www.enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html (accessed 2026-03-22).
