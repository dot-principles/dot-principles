# CODE-CS-HYRUMS-LAW - Hyrum's Law

**Layer:** 2 (contextual)
**Categories:** api-design, compatibility, maintainability
**Applies-to:** apis, libraries, public interfaces
**Summary:** Treat all observable behaviors as implicit API contract; any change may break a consumer.

## Principle

With a sufficient number of users of an API, it does not matter what you promise in the contract: all observable behaviors of your system will be depended on by somebody. Response time, error message wording, output ordering, incidental side effects, undocumented fields - if it is observable and consistent, someone will rely on it. Every change, no matter how innocuous, has the potential to break a consumer.

## Why it matters

API contracts define intent, but users depend on behaviour. The gap between documented interface and observable implementation grows with adoption. Teams that assume freedom to change anything not explicitly documented will break real consumers. This has direct implications for API versioning, change management, and the cost of maintaining widely-adopted libraries: the effective contract is larger than the written one.

## Violations to detect

- Changing response field ordering, error message text, or timestamp precision and assuming no consumer depends on it
- Removing behaviour described as "implementation detail" or "not guaranteed" without surveying actual consumer usage
- Incrementing a major version and changing multiple observable behaviours simultaneously, assuming users will read the changelog
- Adding caching or batching to a method and assuming the changed timing/ordering won't affect consumers

## Good practice

- Treat all observable behaviour of a widely-used API as potentially load-bearing, even if undocumented
- Use explicit versioning and deprecation periods before changing observable behaviour
- When you must change undocumented behaviour, communicate proactively - do not rely on the contract to define what users notice
- Design new APIs to minimise observable surface: fewer fields, less predictable ordering, explicit randomisation where order is not guaranteed - this reduces the accidental contract

## Sources

- Wright, Hyrum. "Hyrum's Law." https://www.hyrumslaw.com
- Winters, Titus; Manshreck, Tom; Wright, Hyrum. *Software Engineering at Google*. O'Reilly, 2020. ISBN 978-1-492-08279-8. Chapter 3.
