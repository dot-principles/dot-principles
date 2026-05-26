# CODE-CS-PARETO - The 80/20 Rule (Pareto Principle)

**Layer:** 2 (contextual)
**Categories:** pragmatism, performance, prioritisation
**Applies-to:** all
**Summary:** Focus effort on the high-impact 20% of code paths, bugs, and features; deprioritize the rest.

## Principle

Roughly 80% of outcomes come from 20% of causes. In software, this means 80% of production traffic hits 20% of code paths, 80% of bugs originate in 20% of the codebase, and 80% of value is delivered by 20% of features. Identify and focus effort on the high-impact 20%; do not optimise, gold-plate, or obsess over the low-impact 80%.

## Why it matters

Engineering time is finite. Applying uniform effort across all code, all features, and all performance paths is a misallocation. The Pareto distribution is empirically observable in software systems - hot paths, bug clusters, and feature usage all follow it. Teams that invest disproportionately in the high-impact minority ship faster, have more reliable systems, and avoid wasting effort on code that almost no one runs.

## Violations to detect

- Optimising code paths that profiling shows carry less than 1% of traffic
- Implementing edge-case features at the same cost as high-usage workflows
- Applying the same level of test coverage and review rigour to rarely-executed admin utilities as to the core transaction path
- Uniform error-handling investment regardless of how often a code path is actually reached in production

## Good practice

- Profile before optimising: identify the 20% of code paths that carry 80% of load, then focus there
- Use usage data (analytics, logs, feature flags) to identify the 20% of features that deliver 80% of value before planning new work
- Apply tiered quality standards: higher coverage, stricter review, and more thorough testing for high-impact paths
- Regularly prune low-usage features - code that serves 1% of users at 20% of maintenance cost is a poor trade

## Sources

- Pareto, Vilfredo. Original distribution observation, 1896.
- Juran, Joseph M. *Juran's Quality Handbook*, 5th ed. McGraw-Hill, 1999. (popularised in engineering contexts)
- Knuth, Donald. "An empirical study of FORTRAN programs." *Software: Practice and Experience*, 1971. (80% of execution time in 20% of code)
