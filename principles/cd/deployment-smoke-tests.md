# CD-DEPLOYMENT-SMOKE-TESTS - Run a minimal automated test suite after every deployment to verify the service is alive before routing real traffic

**Layer:** 2
**Categories:** devops, continuous-delivery, testing, deployment, reliability
**Applies-to:** all
**Summary:** Run automated smoke tests after every deployment to verify core functionality before routing real traffic.

## Principle

Immediately after deploying to any environment, run a small set of automated tests - smoke tests or deployment verification tests - that exercise the most critical paths of the service. These tests do not replace a full acceptance suite; they answer one question: "Did the deployment succeed and is the service basically functional?" If smoke tests fail, halt the pipeline and revert before real traffic is affected.

## Why it matters

A deployment can complete without errors at the infrastructure level while the application itself is broken - a misconfigured environment variable, a missing secret, or a bad startup path can silently disable core functionality. Smoke tests catch these failures before users do. Running them after every deployment, not just in staging, ensures that production deployments are verified rather than assumed to have succeeded.

## Violations to detect

- Deployment pipeline with no post-deploy test step of any kind
- Smoke tests defined only for staging but not run after production deployments
- Health check endpoint that returns 200 but is not backed by an actual dependency check (database, cache, downstream services)
- Smoke tests that exist in the repository but are never executed as part of the pipeline
- Manual verification steps ("log in and check that the homepage loads") as a substitute for automated smoke tests

## Inspection

```bash
# Look for smoke test directories or files
find . -type d \( -name "smoke*" -o -name "*smoke*" \)
find . \( -name "*smoke*" \) \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" \)
```

## Good practice

- Keep the smoke test suite small and fast - under two minutes; it should test happy paths, not edge cases
- Include connectivity checks: can the service reach its database, cache, and critical downstream APIs?
- Run smoke tests against the exact deployed instance before routing traffic (blue-green or canary) - not against a separate test environment
- Automate rollback: if smoke tests fail, the pipeline should revert the deployment without human intervention
- Tag smoke tests clearly in the test framework so they can be run in isolation

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 8.
