# CD-FAST-FEEDBACK-LOOPS - Optimise the pipeline so engineers know within minutes whether a change is safe

**Layer:** 1
**Categories:** devops, continuous-delivery, testing, pipeline
**Applies-to:** all
**Summary:** Structure the pipeline to return a pass or fail signal to the developer within ten minutes.
**Audit-scope:** limited - actual pipeline duration requires observing CI runs; code and pipeline config can reveal obvious serial bottlenecks or missing parallelization.

## Principle

The deployment pipeline must return a pass or fail signal to the developer as quickly as possible - ideally within ten minutes for the initial commit stage. Long pipelines discourage integration, lead to context switching, and delay detection of defects. Achieve speed through parallelism, test isolation, and by running the fastest, broadest-coverage checks first.

## Why it matters

A pipeline that takes hours to run teaches developers to batch their commits, avoid running tests locally, and tolerate broken builds. A fast pipeline makes small, frequent integration safe and natural. The DORA research consistently identifies feedback speed as one of the strongest predictors of software delivery performance.

## Violations to detect

- All test stages run sequentially when they could run in parallel
- Unit tests, integration tests, and end-to-end tests mixed in a single stage with no ordering or fail-fast
- No parallelization configured in CI despite a large test suite
- Pipeline jobs that poll or sleep unnecessarily instead of using event-driven triggers
- No distinction between a fast "commit stage" and slower later stages - everything runs on every push

## Good practice

- Structure the pipeline in stages: commit stage (unit tests, linting, fast checks) → acceptance stage → deployment stage
- Run the commit stage in under ten minutes; use parallelism to achieve this as the suite grows
- Run independent test suites concurrently rather than sequentially
- Fail fast: if any check in a stage fails, abort that stage immediately without running remaining jobs
- Cache dependencies and build artefacts so stages do not re-download or re-compile unnecessarily

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 3.
- Forsgren, Nicole, Jez Humble, and Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. ISBN 978-1-942788-33-1.
