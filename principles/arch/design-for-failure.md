# ARCH-DESIGN-FOR-FAILURE - Assume failure; design around it

**Layer:** 2 (contextual)
**Categories:** architecture, resilience, fault-tolerance, distributed-systems
**Applies-to:** distributed-systems, microservices, cloud-native
**Summary:** Assume every component will fail; design for graceful degradation rather than cascading outage.

## Principle

Assume every component will fail. Design systems so that partial failure is the normal operating mode, not an edge case. No component should be a single point of failure; every integration must assume the dependency may be unavailable and degrade gracefully rather than cascade into total outage.

## Why it matters

In distributed systems, failure is not an exception - it is a certainty. Networks partition, third-party APIs go down, databases become unavailable, and services exhaust their resources. Systems designed assuming success propagate failures as cascades that take down everything. Systems designed assuming failure route around problems, shed load gracefully, and maintain partial functionality during degraded conditions. The cost of designing for failure is low; the cost of not doing so is borne entirely at incident time.

## Violations to detect

- A single database, queue, or service that, if unavailable, makes the entire system non-functional
- Synchronous calls to external services with no timeout, retry policy, or fallback
- No bulkhead isolation - a single slow dependency can exhaust the thread pool of the entire application
- No circuit breaker - failed dependencies are retried indefinitely rather than failing fast
- No defined fallback for any integration - the only response to a dependency being down is a 500 error

## Good practice

- Apply the bulkhead pattern: isolate dependencies into separate thread pools or resource pools so one failure cannot exhaust shared capacity
- Implement circuit breakers on all synchronous inter-service calls with explicitly defined open, closed, and half-open transitions
- Define fallback behaviour for every integration: what does the system return when a dependency is unavailable?
- Identify which features can function without each dependency and preserve that partial availability
- Exercise failure paths deliberately with controlled fault injection (chaos engineering) before incidents do it for you

## Sources

- Nygard, Michael T. *Release It!*, 2nd ed. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-239-8. Chapters 4-6.
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1-4920-3402-5. Chapter 12.
