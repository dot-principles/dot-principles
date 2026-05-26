# EIP-CONTENT-BASED-ROUTER - Content-Based Router

**Layer:** 2 (contextual)
**Categories:** integration, messaging
**Applies-to:** all
**Summary:** Route messages to downstream channels based on content in a dedicated Router, never inside consumers.

## Principle

Route a message to different downstream channels or consumers based on the content of the message itself. The routing decision belongs in a dedicated Router component, not in the downstream consumers. Each consumer should receive only the messages it needs and should not need to inspect message content to decide whether to process it.

## Why it matters

Without a Content-Based Router, each consumer must inspect all messages and filter out irrelevant ones, duplicating routing logic across multiple consumers and coupling each consumer to the full message schema of all producers. This produces fragile fan-out relationships that break whenever a new message type is added.

## Violations to detect

- Consumers that begin with a large `if` / `switch` block inspecting message type or content to decide whether to process the message - the routing logic belongs in a router, not the consumer
- Routing conditions duplicated across multiple consumers that each handle a different message type
- New message types requiring modifications to existing consumer code to handle or ignore them

## Good practice

- Define a router stage in the pipeline that inspects message content and routes to the appropriate channel
- Consumers subscribe to channels that contain only the messages they need; they do not need to inspect content
- Use a rules engine or routing table that can be updated without changing consumer code
- Test the router independently of the consumers

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Chapter 7, "Content-Based Router."
