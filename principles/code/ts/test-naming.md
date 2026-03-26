# CODE-TS-TEST-NAMING — Name tests by the behavior they verify

**Layer:** 2 (contextual)
**Categories:** testing, quality
**Applies-to:** all
**Summary:** Name tests as behavior specifications that state context, action, and expected outcome without reading the body.

## Principle

A test name should describe the behavior or scenario being verified, not the method being called. Good test names read as specifications: they state the context, action, and expected outcome. When a test fails, its name should tell the developer what behavior is broken without reading the test body.

## Why it matters

Test names serve as living documentation of the system's behavior. When named by method (`testCalculate`, `testProcess`), they communicate nothing about what the system should do. Behavior-oriented names (`rejects_order_when_inventory_is_insufficient`) turn the test suite into a readable specification that developers and stakeholders can scan to understand system capabilities.

## Violations to detect

- Test names that simply repeat the method under test (`testSave`, `testValidate`, `testProcess`)
- Generic names with numeric suffixes (`testCase1`, `testCase2`, `testCase3`)
- Names that describe implementation steps rather than expected behavior
- Names so long they are unreadable, indicating the test may be verifying too much
- Names that do not mention the expected outcome or condition

## Good practice

- Use a naming pattern that communicates context and expectation: `[action/scenario]_[expected result]` or `should [expected behavior] when [condition]`
- Include the relevant condition or edge case in the name (`empty_cart_returns_zero_total`)
- Write names that read as sentences when the test class or describe block provides the subject
- Update test names when the behavior they verify changes — stale names are misleading

## Sources

- Beck, Kent. *Test Driven Development: By Example*. Addison-Wesley, 2002. ISBN 978-0-321-14653-3.
- North, Dan. "Introducing BDD." https://dannorth.net/introducing-bdd/
