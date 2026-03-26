# ARCH-MICROKERNEL — Microkernel Architecture

**Layer:** 2 (contextual)
**Categories:** architecture, extensibility, plugin
**Applies-to:** all
**Summary:** Separate a minimal stable core from plugin modules that extend it only through the published plugin API.

## Principle

Separate a minimal, stable core system from extensible plugin modules. The core defines the plugin API and manages plugin lifecycle; plugins implement that API to add behaviour. Plugins must not access core internals or other plugins directly — only through the published extension API. The core must remain functional without any plugins installed.

## Why it matters

Embedding all optional functionality in the core produces a monolith that must be fully deployed to change any part of it. A microkernel architecture allows teams to add, update, or remove plugins independently, without modifying or redeploying the core. It also constrains the blast radius of plugin bugs: a broken plugin cannot corrupt the core's data model or crash unrelated plugins.

## Violations to detect

- Plugin code importing core internals rather than the core's published extension API
- Core code that is not functional without at least one specific plugin installed
- Plugins calling each other directly rather than through events or core-mediated dispatch
- Core that exposes its internal data model to plugins without a stable API contract

## Good practice

- Define the plugin API as a versioned contract (interface, trait, abstract class) in the core
- Plugins depend on the core contract; the core never depends on specific plugins
- Load plugins dynamically (via service discovery, SPI, or explicit registration)
- Write at least one integration test that loads no plugins and verifies the core starts cleanly

## Sources

- Buschmann, Frank et al. *Pattern-Oriented Software Architecture Vol. 1: A System of Patterns*. Wiley, 1996. ISBN 978-0471958697. Chapter 3, "Microkernel."
