# EIP-CLAIM-CHECK — Claim Check

**Layer:** 2 (contextual)
**Categories:** integration, messaging, performance
**Applies-to:** all
**Summary:** Store large payloads externally and pass only a lightweight claim-check reference through the message bus.

## Principle

When a message payload is too large to pass through the message bus efficiently or safely, store the payload in an external data store and include only a reference — a claim check — in the message. Consumers that need the payload retrieve it from the data store using the reference. The message bus carries only lightweight references, not bulk data.

## Why it matters

Message brokers impose payload size limits (typically 256 KB–1 MB). Large payloads bloat broker storage, increase network transfer time for all consumers, and degrade broker throughput for unrelated messages. The Claim Check pattern keeps the message bus lean while still enabling large-payload workflows.

## Violations to detect

- Messages containing large binary payloads (images, documents, large JSON blobs) published directly to a message queue or topic, violating broker size limits or degrading throughput
- All consumers receiving the full large payload even when most only need the metadata in the message header
- No expiry or cleanup policy for stored payloads, leading to unbounded growth in the data store

## Good practice

- Write the large payload to object storage (S3, Azure Blob, GCS) before publishing the message
- Include the storage URI and a content hash in the message
- Consumers retrieve the payload only if they need it
- Define and enforce a retention policy on the payload store to prevent unbounded accumulation
- Sign the storage URI or use short-lived access tokens to control who can retrieve payloads

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Chapter 9, "Claim Check."
