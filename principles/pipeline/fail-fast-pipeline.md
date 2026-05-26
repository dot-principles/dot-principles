# PIPELINE-FAIL-FAST-PIPELINE - Abort the pipeline on the first meaningful failure

**Layer:** 1 (universal)
**Categories:** reliability, pipeline, efficiency
**Applies-to:** pipeline
**Summary:** Abort the pipeline on the first stage failure; never suppress errors in build, test, or deploy steps.

## Principle

When a pipeline stage fails, subsequent dependent stages must not execute. The pipeline should abort as early as possible and report the failure clearly, rather than continuing to run downstream stages whose results are meaningless because an upstream dependency failed. Allow-failure and continue-on-error directives must be used sparingly and only for explicitly non-blocking checks - never for core build, test, or deploy stages.

## Why it matters

A pipeline that continues after failure wastes compute resources, delays feedback, and produces confusing results. Developers see green deploy stages downstream of a red test stage and may wrongly assume the deployment succeeded on tested code. In the worst case, a pipeline that deploys despite test failures puts broken code into production. Fail-fast pipelines give developers clear, immediate feedback on the first thing that broke.

## Violations to detect

- `continue-on-error: true` on build, test, or deploy steps in GitHub Actions
- `allow_failure: true` on critical stages in GitLab CI
- `|| true` or `set +e` appended to commands in pipeline scripts to suppress failures
- Deploy stages that run unconditionally regardless of test stage outcomes (no `needs:` or `depends_on:` dependencies)
- `when: always` or `when: on_failure` on deploy steps that should only run after a successful test
- Missing stage dependencies in CI configuration - stages run in parallel when they should be sequential with failure propagation
- `try/catch` blocks in Jenkinsfile that silently swallow stage failures

## Inspection

- `grep -rnE 'continue-on-error:\s*true' --include="*.yml" --include="*.yaml" $TARGET` | HIGH | continue-on-error suppresses failures
- `grep -rnE 'allow_failure:\s*true' --include="*.yml" --include="*.yaml" $TARGET` | HIGH | allow_failure suppresses stage failures
- `grep -rnE '\|\|\s*true|set \+e' --include="*.yml" --include="*.yaml" --include="Jenkinsfile" --include="*.sh" $TARGET` | HIGH | Shell error suppression in pipeline scripts

## Good practice

- Define explicit stage dependencies so that deploy stages only run after all test stages succeed
- Use `needs:` (GitHub Actions), `needs:` or `dependencies:` (GitLab CI), or `dependsOn` (Azure Pipelines) to express stage ordering
- Reserve `continue-on-error` for genuinely non-blocking advisory checks (e.g., optional linting, coverage reporting)
- In Jenkinsfile, let stage failures propagate naturally rather than wrapping in try/catch
- Configure the pipeline to report the first failure prominently - not buried under subsequent stage outputs
- Use `set -euo pipefail` at the top of bash scripts in pipeline steps to catch command failures, unset variables, and pipe failures

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 3.
- Forsgren, Nicole, Jez Humble, and Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. ISBN 978-1-942788-33-1.
