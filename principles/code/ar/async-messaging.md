# CODE-AR-ASYNC-MESSAGING — Use messaging for asynchronous integration between services

**Layer:** 2 (contextual)
**Categories:** architecture, integration, distributed-systems
**Applies-to:** all
**Summary:** Prefer asynchronous messaging over synchronous calls whenever the sender does not need an immediate response.

## Principle

Prefer asynchronous messaging over synchronous remote procedure calls when integrating services that do not require an immediate response. By placing messages on a channel, the sender can continue processing without blocking on the receiver's availability or response time. This temporal decoupling makes the overall system more resilient and allows components to evolve, scale, and fail independently.

## Why it matters

Synchronous calls between services create tight runtime coupling — if the downstream service is slow or unavailable, the caller blocks or fails. Asynchronous messaging absorbs transient failures, smooths load spikes through buffering, and allows producers and consumers to operate at different speeds. This is foundational to building systems that remain responsive under real-world conditions.

## Violations to detect

- Synchronous HTTP calls between services where the caller does not need an immediate result
- Chains of blocking remote calls that create deep request-level coupling across multiple services
- Fire-and-forget patterns implemented without a durable messaging channel (e.g., spawning a background thread with no persistence or retry)
- Services that poll a database table as a makeshift message queue instead of using a proper messaging infrastructure

## Good practice

- Use a message queue or event broker (e.g., RabbitMQ, Kafka, Amazon SQS) for inter-service communication that does not require a synchronous response
- Design messages as self-contained, immutable documents that carry all the data the consumer needs
- Implement dead-letter queues to capture messages that cannot be processed, enabling investigation without data loss
- Keep message contracts explicit and versioned to allow independent deployment of producers and consumers

## Sources

- Hohpe, Gregor; Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0-321-20068-6. Chapter 3: "Messaging Systems."
