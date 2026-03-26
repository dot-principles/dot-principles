# EIP-SPLITTER — Splitter

**Layer:** 2 (contextual)
**Categories:** integration, messaging
**Applies-to:** all
**Summary:** Decompose composite messages into individual sub-messages and emit a correlation identifier on each one.

## Principle

A Splitter decomposes a single composite message that contains multiple items into a series of individual messages, one per item, each of which can then be processed, routed, and transformed independently. The Splitter must emit a correlation identifier on each sub-message so that downstream components can associate individual results with the originating composite, and downstream processors can determine when all sub-messages for a given composite have been handled.

## Why it matters

When splitting is implemented ad hoc — iterating a collection and publishing directly inside a business-logic method — the splitting concern becomes entangled with routing, transformation, and processing logic. The result is code where a single method reads, splits, routes, and partially processes messages, making it impossible to test or reuse any one concern independently. Without correlation on each sub-message, downstream processors cannot aggregate results back or track whether all items were successfully processed.

## Violations to detect

- A `for` loop or `forEach` that iterates a collection and calls a message producer directly, embedding splitting in a business service method rather than a dedicated component
- Sub-messages that carry no correlation identifier linking them back to the originating composite message
- No mechanism to track completion: the system cannot determine when all items from a split have been successfully processed
- Splitting logic duplicated across multiple services each independently iterating the same composite message type
- No error handling for partial failures: if one sub-message fails, there is no strategy for the remaining items or for the original composite

## Good practice

- Use a messaging framework's splitter abstraction (Spring Integration `@Splitter`, Apache Camel `split()`) to keep splitting separated from business logic
- Add a correlation ID and a sequence number to each sub-message, along with the total count, so downstream processors and aggregators can track completeness
- Pair the Splitter with an Aggregator when the results of individual processing steps must be recombined into a composite reply
- Handle partial failures explicitly: dead-letter failed sub-messages and decide whether to fail the whole batch or accept partial success
- Test the splitter in isolation — verify it emits the correct number of sub-messages with the correct payloads and metadata

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Splitter."
- Hohpe, Gregor & Woolf, Bobby. "Splitter." https://www.enterpriseintegrationpatterns.com/patterns/messaging/Sequencer.html (accessed 2026-03-22).
