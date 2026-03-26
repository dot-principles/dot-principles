# CODE-TS-PROPERTY-BASED-TESTING — Specify invariants and let the framework generate inputs to find edge cases

**Layer:** 2 (contextual)
**Categories:** testing, quality

**Applies-to:** all
**Summary:** Specify invariants that must hold for any valid input and let the framework generate and shrink test cases.

## Principle

Property-based testing replaces hand-picked example inputs with invariants: statements that must hold for any valid input. A framework (QuickCheck, Hypothesis, fast-check, jqwik) generates hundreds of random inputs, tries to falsify each invariant, and — when a failure is found — shrinks the input to the minimal failing case. This surfaces edge cases that example-based tests routinely miss.

## Why it matters

Example-based tests verify that the code works for the inputs the author thought of. Property-based tests verify that it works for inputs the author did not think of. Entire classes of bugs — off-by-one errors, overflow on boundary values, unexpected behaviour on empty or unicode input — are found automatically rather than discovered in production.

## Violations to detect

- Test suites for pure functions or data transformations that contain only hand-written examples with no property-based coverage
- Parsers, serialisers, encoders, or mathematical functions tested exclusively with a handful of fixed inputs
- Round-trip properties (encode → decode = identity, serialise → deserialise = identity) verified only for one or two specific values
- Tests that enumerate edge cases manually (empty string, null, zero, max int) instead of using a generator that covers the entire domain

## Good practice

- Start with the simplest universal properties: round-trips, idempotency (`f(f(x)) == f(x)`), commutativity, and "doesn't throw on any valid input"
- Use shrinking: most frameworks shrink automatically; confirm that the minimal failing case is reported before acting on the failure
- Seed the random generator for reproducible CI failures; re-run with a fixed seed to reproduce locally
- Combine with example-based tests — property tests find unknown unknowns; example tests document known important cases

## Sources

- Claessen, Koen and Hughes, John. "QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs." *ACM SIGPLAN Notices*, 2000. DOI: https://doi.org/10.1145/357766.351266.
- MacIver, David. *Hypothesis Documentation*. https://hypothesis.readthedocs.io/ (authoritative framework documentation).
- Scott, Wlaschin. "An introduction to property-based testing." https://fsharpforfunandprofit.com/posts/property-based-testing/ (2014).
