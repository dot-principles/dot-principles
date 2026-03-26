# CD-BUILD-ONCE-DEPLOY-MANY — Compile and package the artifact exactly once; promote that same immutable artifact through every environment

**Layer:** 1
**Categories:** devops, continuous-delivery, deployment, reliability
**Applies-to:** all
**Summary:** Build the artifact once and promote that same immutable artifact through every environment.

## Principle

The build stage produces one artifact — a Docker image, a compiled binary, a JAR — tagged with a unique version or commit SHA. That exact artifact is deployed to every subsequent environment: integration, staging, production. If a build is required again for a different environment, the build process is broken. Environment-specific behaviour is injected via configuration at deploy time, not compiled in.

## Why it matters

Rebuilding for each environment introduces uncontrolled variables. Dependencies may have updated, build tools may behave differently, or environment-specific flags may accidentally change behaviour. If an artifact passed all tests in staging and a different artifact is deployed to production, the tests are worthless. One artifact is the only way to guarantee that what was tested is what runs.

## Violations to detect

- Separate build targets per environment (`make build-dev`, `make build-prod`, `docker build --target prod`)
- CI pipeline that runs `docker build` or equivalent once for staging and again for production
- Environment-specific feature flags or configuration baked into the build rather than injected at runtime
- Artifacts identified only by branch name or "latest" tag rather than an immutable version or commit SHA
- Deployment scripts that re-compile from source rather than pulling a pre-built artifact

## Inspection

```bash
# Look for environment-specific build targets in Makefiles
grep -n "build-dev\|build-staging\|build-prod\|build-test\|build-qa" Makefile 2>/dev/null

# Look for environment-specific Dockerfiles
ls Dockerfile.dev Dockerfile.staging Dockerfile.prod Dockerfile.production 2>/dev/null
```

## Good practice

- Tag every artifact with the commit SHA or a semantic version at build time; never use mutable tags like `latest` in production
- Use a container registry (ECR, GCR, Docker Hub) or artifact repository (Nexus, Artifactory) as the promotion mechanism — the same image digest moves from dev to prod
- Inject all environment-specific configuration via environment variables or a mounted secrets store at runtime
- Record the artifact version in your observability stack so every metric and log can be correlated with the exact code that produced it

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 5.
