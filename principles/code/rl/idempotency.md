# CODE-RL-IDEMPOTENCY — Make operations idempotent to enable safe retries

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Design operations so repeated execution produces the same result, enabling safe retries without side effects.

## Principle

Design operations so that performing them multiple times produces the same result as performing them once. In a distributed system, messages can be delivered more than once, retries can re-execute a request whose original attempt actually succeeded, and clients may resubmit after a timeout. If operations are idempotent, these duplicates are harmless — the system converges to the correct state regardless of how many times the operation is applied.

## Why it matters

Network communication provides at-most-once or at-least-once delivery, but exactly-once is extremely difficult to achieve in practice. When a client times out waiting for a response, it cannot know whether the server processed the request. If the operation is not idempotent, retrying it may create duplicate records, apply a charge twice, or corrupt state. Idempotency transforms the "is it safe to retry?" question from a dangerous gamble into a routine recovery mechanism.

## Violations to detect

- Write operations that lack an idempotency key or natural deduplication mechanism, making duplicates undetectable
- API endpoints where resubmitting the same request creates duplicate resources or applies side effects multiple times
- Message consumers that process the same message twice and produce different outcomes each time
- Counter increments or balance adjustments performed without checking whether the specific operation was already applied

## Good practice

- Assign a unique idempotency key to each operation and track which keys have been processed, ignoring duplicates
- Design state mutations as "set to value X" rather than "increment by Y" where possible — absolute assignments are naturally idempotent
- Use database constraints (unique indexes, conditional writes) as a safety net to prevent duplicate effects
- In event-driven systems, record the offset or sequence number of the last processed event so that reprocessing skips already-applied events

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 11: "Stream Processing."
