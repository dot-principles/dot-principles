# ARCH-SAGA — Saga Pattern

**Layer:** 2 (contextual)
**Categories:** architecture, distributed-systems, reliability
**Applies-to:** all
**Summary:** Coordinate distributed transactions as a sequence of local transactions with compensating steps on failure.

## Principle

Coordinate long-running distributed transactions across multiple services using a sequence of local transactions. Each step in the saga publishes an event or sends a command that triggers the next step. If a step fails, the saga executes compensating transactions to undo the preceding steps and restore consistency.

## Why it matters

Two-phase commit (2PC) across service boundaries requires a distributed lock that degrades availability and creates coupling. Sagas achieve eventual consistency without distributed locks — each service commits its local transaction independently and publishes an event. The trade-off is that the intermediate states are visible and compensation logic must be explicitly designed.

## Violations to detect

- Two-phase commit / XA transactions spanning multiple services
- Business flows that require all-or-nothing consistency across service boundaries with no explicit compensation logic
- Saga steps that hold locks between local transactions
- Missing compensating transaction for any saga step that can fail

## Good practice

- Choose between choreography (each service reacts to events) and orchestration (a saga orchestrator sends commands)
- Design compensating transactions for every step before writing the happy path
- Make saga steps idempotent so retries are safe
- Log saga state explicitly so incomplete sagas can be detected and resumed

## Sources

- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1617294549. Chapter 4.
- Garcia-Molina, H. & Salem, K. "Sagas." *SIGMOD Record*, 1987. DOI: 10.1145/38714.38742.
