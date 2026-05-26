# CODE-RL-BACKPRESSURE - Apply backpressure to protect systems from overload

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Signal producers to slow down when consumers are overwhelmed; never buffer unboundedly or drop silently.

## Principle

When a component receives work faster than it can process it, it must signal the producer to slow down rather than buffering unboundedly or dropping work silently. Backpressure is the mechanism by which a downstream consumer communicates its capacity limits upstream, allowing the system to degrade gracefully under load rather than collapsing. This applies to in-process pipelines, service-to-service communication, and stream processing alike.

## Why it matters

Without backpressure, a fast producer paired with a slow consumer leads to unbounded queue growth, memory exhaustion, and eventual system failure. Alternatively, if overflow is handled by silently dropping messages, data loss occurs without anyone knowing. Backpressure makes overload visible and controllable - the system either slows down to a sustainable rate or explicitly rejects excess work, giving operators and upstream callers the information they need to respond.

## Violations to detect

- Unbounded in-memory queues between a producer and consumer with no capacity limit or flow-control mechanism
- Producers that push data to consumers without any feedback channel to signal that the consumer is overwhelmed
- Systems that handle overload by silently dropping messages or events with no logging, metric, or notification
- Asynchronous pipelines where memory usage grows proportionally to input rate because there is no bound on buffered work

## Good practice

- Use bounded queues or buffers with explicit capacity limits, and define what happens when the limit is reached (block, reject, or drop with notification)
- Implement pull-based consumption where possible - let the consumer request work at its own pace rather than having the producer push at an arbitrary rate
- Expose metrics for queue depth, rejection rate, and processing lag so that overload conditions are detected early
- In reactive or streaming systems, use protocols that support backpressure natively (e.g., Reactive Streams, TCP flow control, Kafka consumer lag)

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 11: "Stream Processing."
- Reactive Streams Specification. https://www.reactive-streams.org/
