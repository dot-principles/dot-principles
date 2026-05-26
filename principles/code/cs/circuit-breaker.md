# CODE-CS-CIRCUIT-BREAKER - Use circuit breakers to prevent cascade failures

**Layer:** 2 (contextual)
**Categories:** reliability, distributed-systems
**Applies-to:** all
**Summary:** Wrap calls to external dependencies in a circuit breaker to stop cascading failures automatically.

## Principle

Wrap calls to external dependencies in a circuit breaker that monitors for failures and, after a threshold is reached, stops making calls for a cooldown period. In the closed state the breaker allows calls through normally. When failures accumulate past the threshold, it trips to the open state - immediately failing subsequent requests without attempting the call. After a timeout, it enters a half-open state, allowing a limited number of probe requests to test whether the dependency has recovered.

## Why it matters

Without a circuit breaker, a failing dependency consumes the caller's resources - threads block on timeouts, connection pools fill, and the caller itself becomes unresponsive, propagating the failure upstream in a cascade. A circuit breaker fast-fails when a dependency is known to be unhealthy, freeing resources to serve requests that can still succeed. It also gives the failing dependency breathing room to recover instead of being hammered with requests it cannot handle.

## Violations to detect

- Remote calls that retry aggressively against a failing service with no mechanism to back off or stop
- Thread pools or connection pools that are exhausted because calls to an unresponsive dependency are blocking indefinitely
- Systems where a single failing downstream service causes the entire application to become unresponsive
- Retry logic with no upper bound on attempts and no transition to a failure state

## Good practice

- Implement circuit breakers on all calls to external services, databases, and third-party APIs
- Configure sensible thresholds - failure count, failure rate, and timeout window - based on the dependency's expected behavior
- Provide meaningful fallback behavior when the circuit is open: serve cached data, return a default, or degrade the feature gracefully
- Monitor circuit breaker state transitions (closed to open, open to half-open) with alerts so that operations teams are aware of dependency problems

## Sources

- Nygard, Michael T. *Release It! Design and Deploy Production-Ready Software*, 2nd ed. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-239-8. Chapter 5: "Stability Patterns."
