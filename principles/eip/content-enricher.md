# EIP-CONTENT-ENRICHER — Content Enricher

**Layer:** 2 (contextual)
**Categories:** integration, messaging, maintainability
**Applies-to:** all
**Summary:** Enrich messages with additional data at a dedicated pipeline boundary before they reach downstream consumers.

## Principle

A Content Enricher augments an incoming message with additional data — looked up from a data store, a service call, or a local computation — before passing the enriched message downstream. The enrichment concern belongs in a dedicated component at the pipeline boundary. No downstream consumer should need to perform its own enrichment lookups for data that could have been added upstream.

## Why it matters

When enrichment is embedded in consumer logic, the same lookup is duplicated across every consumer that needs the additional data. Changing the data source or the lookup strategy requires changing every consumer. Consumers that perform enrichment are harder to test because they require the enrichment data source to be available as a test dependency. A dedicated Content Enricher centralises the lookup and makes downstream consumers simple: they receive fully populated messages and can focus entirely on processing.

## Violations to detect

- Multiple consumers each making the same external lookup (database query, API call) to retrieve the same additional data for the same message type
- Enrichment data fetched inside a message handler that is expected to complete quickly, but the fetch blocks the handler thread on a slow or unavailable dependency
- Enrichment logic that is not independently testable — it can only be tested end-to-end with the full consumer pipeline active
- A consumer that receives a sparse message and immediately queries the originating system to reconstruct a fully populated view — the producer should have emitted a richer event, or the enricher should have augmented it at the boundary

## Good practice

- Place the Content Enricher as a discrete pipeline stage between the inbound channel and the processing consumers
- Cache frequently enriched data with an appropriate TTL to avoid per-message round-trips to a slow data source
- Fail or dead-letter the message in the enricher if required enrichment data cannot be retrieved — do not pass an incompletely enriched message downstream to be silently mishandled
- Test the enricher in isolation: given an input message, assert the expected fields are added without testing any downstream processing logic

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Content Enricher."
- Hohpe, Gregor & Woolf, Bobby. "Content Enricher." https://www.enterpriseintegrationpatterns.com/patterns/messaging/DataEnricher.html (accessed 2026-03-22).
