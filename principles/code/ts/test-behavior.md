# CODE-TS-TEST-BEHAVIOR - Test behavior, not implementation

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Test observable behavior through the public contract, never internal implementation details.

## Principle

Tests should specify what a unit of code does, not how it does it. A test coupled to internal structure - such as the order of method calls, private method invocations, or internal data representation - breaks whenever the implementation is refactored, even if the behavior remains correct. Tests should exercise the public contract and verify observable outcomes.

## Why it matters

Implementation-coupled tests punish refactoring. Every internal change forces test updates, even when behavior is unchanged, which discourages developers from improving code structure. Behavior-focused tests remain stable across refactorings, making them a true safety net rather than a maintenance burden.

## Violations to detect

- Assertions on private methods or internal state that is not part of the public contract
- Mocks that verify the exact sequence or count of internal method calls
- Tests that break after a refactoring even though the externally observable behavior is unchanged
- Tests that mirror the production code's control flow step by step
- Excessive use of mocks to verify interaction details rather than outcomes

## Good practice

- Assert on return values, output state, published events, or observable side effects
- Use mocks sparingly - prefer verifying outcomes over verifying interactions
- Write tests against the public API of the module or class, not its internals
- Ask "if I refactored the internals, would this test still pass?" - if not, the test is too coupled

## Sources

- Beck, Kent. *Test Driven Development: By Example*. Addison-Wesley, 2002. ISBN 978-0-321-14653-3.
- Freeman, Steve; Pryce, Nat. *Growing Object-Oriented Software, Guided by Tests*. Addison-Wesley, 2009. ISBN 978-0-321-50362-6.
