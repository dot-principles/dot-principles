# CODE-TS-CONSUMER-DRIVEN-CONTRACTS — Let consumers define and verify the contract they need from a provider

**Layer:** 2 (contextual)
**Categories:** testing, quality, api-design

**Applies-to:** all
**Summary:** Let consumers define the API contracts they need and verify providers satisfy all contracts in CI.

## Principle

In a consumer-driven contract test, each consumer of a service records the exact interactions it depends on as a contract. The provider's CI pipeline then verifies that it satisfies every registered consumer contract. This inverts the traditional integration test model: instead of the provider defining what it offers, consumers define what they need, and the provider is held to those expectations.

## Why it matters

Integration tests that use shared test environments are slow, fragile, and create tight scheduling dependencies between teams. Consumer-driven contracts catch breaking API changes before deployment — without standing up real services — and make the impact of a provider change visible to all affected consumers immediately.

## Violations to detect

- Provider services that are tested only with broad smoke tests or manual testing, with no per-consumer contract verification
- Integration tests that require both the provider and consumer services to be deployed simultaneously
- API changes made to a provider with no automated check that existing consumers still work
- Consumer code that duplicates provider response schemas as hand-maintained constants rather than deriving them from a shared contract

## Good practice

- Use a contract testing tool (e.g., Pact) to record consumer interactions and publish contracts to a broker
- Run contract verification in the provider's CI pipeline against all registered consumer contracts before merging
- Version contracts alongside the consumer code that produces them
- Treat a failing provider verification as a breaking change, not a consumer bug

## Sources

- Fowler, Martin. "ConsumerDrivenContracts." https://martinfowler.com/articles/consumerDrivenContracts.html (2006).
- Pact Foundation. "Pact Documentation." https://docs.pact.io/ (authoritative specification and rationale).
- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1-61729-454-9. Chapter 9 "Testing microservices: Part 1".
