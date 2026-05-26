# DDD-OPEN-HOST-SERVICE - Open Host Service

**Layer:** 2 (contextual)
**Categories:** architecture, domain-driven-design, api-design
**Applies-to:** all
**Summary:** Expose a versioned, documented protocol for external contexts to consume while keeping the internal model free to evolve.

## Principle

Define a well-specified protocol for other Bounded Contexts to access your context's capabilities. The Open Host Service is a published, versioned API - REST, gRPC, event schema, or similar - that is stable, documented, and decoupled from the internal domain model. Consumers use this protocol; the internal model is free to evolve independently.

## Why it matters

Without an Open Host Service, other contexts integrate by importing your internal types or accessing your database directly, creating tight coupling to your implementation details. When your internal model changes - as it must - you break all your consumers. A well-defined protocol provides a stable integration surface that absorbs internal change without propagating it to consumers.

## Violations to detect

- Other bounded contexts importing internal domain types from your module/package rather than using a published API or event schema
- Integration that breaks when internal class or field names change because consumers depend on serialised internal objects
- No versioning strategy for the integration contract
- The integration protocol containing internal implementation details (database IDs, internal status codes) that consumers should not know about

## Good practice

- Define the protocol (OpenAPI spec, Protobuf, Avro schema, AsyncAPI) before implementation
- Version it explicitly - consumers depend on the version, not the implementation
- Translate between the internal domain model and the protocol in a dedicated translation layer; never expose internal entities directly
- Write consumer contract tests to verify the protocol remains backward-compatible

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0321125217. Chapter 14.
