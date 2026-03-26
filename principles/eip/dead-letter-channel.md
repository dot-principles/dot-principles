# EIP-DEAD-LETTER-CHANNEL — Dead Letter Channel

**Layer:** 2 (contextual)
**Categories:** integration, messaging, reliability
**Applies-to:** all
**Summary:** Route undeliverable messages to a Dead Letter Channel for inspection and replay instead of discarding them.

## Principle

When a message cannot be delivered or processed successfully after all retry attempts, route it to a dedicated Dead Letter Channel (dead-letter queue) rather than discarding it or blocking the pipeline. The dead-letter channel is a recoverable repository for failed messages that can be inspected, corrected, and replayed.

## Why it matters

Silently discarding undeliverable messages causes silent data loss — business operations that should have been executed are simply never executed, with no alert and no recovery path. Blocking the pipeline on an unprocessable message halts all subsequent messages. A dead-letter channel preserves the message for human inspection or automated recovery, making failure visible and recoverable.

## Violations to detect

- Message consumer `catch` blocks that swallow exceptions and acknowledge the message, causing it to be silently discarded on processing failure
- No dead-letter queue configured for a message channel that handles business-critical operations
- Failed messages that block consumption of subsequent messages from the same queue indefinitely
- No monitoring or alerting on dead-letter queue depth

## Good practice

- Configure a dead-letter queue (or dead-letter exchange in AMQP) for every production message channel handling business-critical work
- Set a maximum delivery count; move to DLQ after N failures
- Alert when DLQ depth is non-zero
- Include original message metadata (failure reason, original topic, timestamp, delivery count) in the dead-lettered message to aid diagnosis
- Implement a supervised replay mechanism

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Chapter 3, "Dead Letter Channel."
