# EIP-MESSAGE-TRANSLATOR — Message Translator

**Layer:** 2 (contextual)
**Categories:** integration, messaging, maintainability
**Applies-to:** all
**Summary:** Translate between message formats in a dedicated Translator so producers and consumers remain fully decoupled.

## Principle

A Message Translator converts a message from one format or schema into another, isolating the translation concern at a dedicated boundary. Each participant in a messaging system speaks its own internal format; the Message Translator sits at the boundary and maps between them. No downstream consumer should need to understand the upstream producer's format, and no producer should need to know a consumer's internal representation.

## Why it matters

When format translation is scattered through service methods rather than confined to a dedicated boundary, the internal domain model becomes coupled to external message schemas. Changes to an external producer's message format require changes throughout the codebase — not just at the integration boundary. Multiple consumers each performing their own translation of the same external format duplicate mapping logic that will drift out of sync. Isolating translation at the boundary means the rest of the system is insulated from external schema changes.

## Violations to detect

- A service method that receives an external DTO and maps it to a domain object inline, mixing translation with business logic in the same method body
- Multiple classes that each independently implement their own mapping from the same external message format, duplicating and potentially diverging in their translation rules
- Domain model classes that have direct dependencies on external message schema types, coupling the core domain to integration concerns
- Translation logic that is neither tested independently nor separable from the service it lives in — a format change requires reasoning about the entire service

## Good practice

- Define an explicit translator class or function for each external-to-internal boundary; the rest of the system uses only the internal representation
- Test the translator in isolation with the expected input/output schema pairs; changes to the external format break only the translator test, not business logic tests
- Use a Canonical Data Model internally so that multiple external adapters each translate into the same internal format rather than directly into each other's formats
- Consider code generation from schemas (OpenAPI, Protobuf, Avro) to keep translator code in sync with external contracts without manual maintenance

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Message Translator."
- Hohpe, Gregor & Woolf, Bobby. "Message Translator." https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageTranslator.html (accessed 2026-03-22).
