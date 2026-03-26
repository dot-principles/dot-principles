# DDD-PUBLISHED-LANGUAGE — Published Language

**Layer:** 2 (contextual)
**Categories:** architecture, domain-driven-design, api-design
**Applies-to:** all
**Summary:** Translate between bounded contexts using a shared, agreed-upon exchange format rather than exposing internal models.

## Principle

Use a shared, well-documented exchange language as the translation medium between Bounded Contexts. The Published Language is a common format — a schema, a standard, or an explicit protocol — that all participating contexts agree on. Neither context exposes its internal model; both translate to and from the Published Language at their boundaries.

## Why it matters

When two bounded contexts integrate directly using each other's models, they create bilateral coupling: context A must understand B's model and vice versa. A Published Language introduces a neutral translation point that both contexts depend on, not on each other. This reduces coupling and makes it possible to add new consumers of the language without modifying existing ones.

## Violations to detect

- Event payloads or API responses that directly serialise internal domain entity structures, forcing consumers to understand the producer's internal model
- Integration that cannot accommodate a new consumer without modifying the producing context
- No schema definition (OpenAPI, Protobuf, Avro, JSON Schema) for the shared exchange format
- Schema changes that break existing consumers because the format was never versioned

## Good practice

- Define the Published Language as a formal schema in a neutral format (Protobuf, Avro, JSON Schema, OpenAPI)
- Version it and publish it where all consumers can access it
- Both producer and consumer translate between their internal models and the schema; neither knows about the other's internals
- Evolve the schema with backward compatibility as a first principle

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0321125217. Chapter 14.
