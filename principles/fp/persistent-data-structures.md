# FP-PERSISTENT-DATA-STRUCTURES — Persistent data structures

**Layer:** 2 (contextual)
**Categories:** functional-programming, performance, data-structures, concurrency
**Applies-to:** all
**Summary:** Use persistent data structures with structural sharing to get immutability guarantees at O(log n) update cost.

## Principle

A persistent data structure preserves all previous versions of itself on every update: a modification produces a new version that shares as much structure as possible with the prior version (structural sharing) without copying the entire structure. This gives the safety guarantees of immutability — old references remain valid and unchanged — while keeping update costs at O(log n) rather than O(n).

## Why it matters

Naive immutability (full copy on write) has prohibitive performance for large data structures. Mutable data structures have prohibitive reasoning and concurrency costs. Persistent data structures with structural sharing resolve this tension: they are safe to share across threads (no copy needed), efficient to update (only the changed path is new), and allow cheap "time travel" (keeping prior snapshots for undo, audit, or transactional rollback).

## Violations to detect

- Deep-copying large data structures on every update when structural sharing would be applicable
- Using mutable data structures in concurrent contexts requiring defensive copies before sharing
- Implementing versioning or undo history by storing complete snapshots rather than shared persistent structures
- Choosing mutability for performance without first measuring whether a persistent structure would be fast enough

## Good practice

- Use the persistent/immutable collection types provided by the language or a well-maintained library: Clojure's built-in persistent maps and vectors; `immutable.js` / `immer` in JavaScript; Scala's `Vector`, `Map`, `Set` from `scala.collection.immutable`; `pyrsistent` in Python
- Prefer persistent structures in the pure functional core; use mutable structures only in the imperative shell where performance demands it and the mutation is local
- Understand the performance characteristics: persistent balanced trees offer O(log n) update and O(log n) lookup; hash-array mapped tries (Clojure, immutable.js) offer near-O(1) for both
- Use structural sharing explicitly when designing your own versioned or historical data models (e.g., append-only event logs with shared prefix)

## Sources

- Okasaki, Chris. *Purely Functional Data Structures*. Cambridge University Press, 1998. ISBN 978-0-521-66350-2.
- Hickey, Rich. "The Value of Values." JaxConf talk, 2012. https://www.infoq.com/presentations/Value-Values/ (accessed 2026-03-16).
- Bagwell, Phil. "Ideal Hash Trees." 2001. https://lampwww.epfl.ch/papers/idealhashtrees.pdf (accessed 2026-03-16).
