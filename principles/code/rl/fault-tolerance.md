# CODE-RL-FAULT-TOLERANCE - Design for fault tolerance - expect and handle partial failures

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Set timeouts on all remote calls and design for graceful degradation when any dependency fails.

## Principle

In a distributed system, partial failures are not exceptional - they are the normal operating condition. Networks partition, nodes crash, disks fill up, and responses arrive late or not at all. Design every inter-process interaction with the assumption that the remote party may be slow, unavailable, or returning stale data. The system as a whole must continue to provide useful service even when individual components are degraded.

## Why it matters

Unlike a single-process application where a failure is typically total and immediate, distributed systems experience partial failures that are ambiguous - you often cannot tell whether a request succeeded, failed, or is still in progress. If software is not designed to handle this ambiguity, a single slow node can bring down the entire system through cascading timeouts, resource exhaustion, or data corruption.

## Violations to detect

- Remote calls made without timeouts, allowing a slow dependency to block the caller indefinitely
- Code that assumes a network call either succeeds or throws - without handling the ambiguous case of a timeout with unknown outcome
- Systems where a single unavailable dependency causes total service failure rather than graceful degradation
- Error handling that treats remote failures the same as local exceptions, without considering retries, fallbacks, or partial results

## Good practice

- Set explicit timeouts on all remote calls and define what happens when the timeout is reached
- Design for graceful degradation - serve cached or partial results when a dependency is unavailable, rather than failing entirely
- Distinguish between transient failures (worth retrying) and permanent failures (not worth retrying) and handle each appropriately
- Test failure modes explicitly - inject network partitions, latency, and node failures using chaos engineering techniques

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 8: "The Trouble with Distributed Systems."
