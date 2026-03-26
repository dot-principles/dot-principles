# EIP-MESSAGE-FILTER — Message Filter

**Layer:** 2 (contextual)
**Categories:** integration, messaging
**Applies-to:** all
**Summary:** Remove unwanted messages in a dedicated Filter component; never duplicate filtering logic in consumers.

## Principle

Remove unwanted messages from a channel using a dedicated Message Filter component before they reach consumers that have no interest in them. The filter applies a selection criterion and silently discards messages that do not satisfy it. Filtering logic must be in the filter, not duplicated in consumers.

## Why it matters

Consumers that receive messages they do not need must either process them wastefully or check and discard them, coupling the consumer to knowledge of the full message stream. A Message Filter upstream of the consumer ensures the consumer receives only relevant messages, simplifying its logic and reducing coupling to unrelated message types.

## Violations to detect

- Consumer code that processes all messages from a channel but immediately returns early for a large percentage of them because most are irrelevant
- Filter predicates implemented differently in multiple consumers that subscribe to the same channel
- Adding a new message type to a channel requiring changes to all existing consumers to handle or ignore it

## Good practice

- Place a filter component between the producer channel and the consumer channel
- Express filter criteria in configuration or a rules engine rather than code, where possible
- Test the filter independently — verify it passes the right messages and drops the right messages
- Distinguish filtering (dropping irrelevant messages) from content-based routing (sending different messages to different channels)

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Chapter 7, "Message Filter."
