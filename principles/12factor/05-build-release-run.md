# 12FACTOR-05-BUILD-RELEASE-RUN — Build, Release, Run

**Layer:** 2 (contextual)
**Categories:** architecture, cloud-native, deployment
**Applies-to:** cloud-native, twelve-factor-apps
**Summary:** Strictly separate build, release, and run stages; every release must be immutable and uniquely identified.

## Principle

Strictly separate the build, release, and run stages. The build stage converts code into an executable bundle. The release stage combines the build with deployment config. The run stage executes the release. Every release is immutable and uniquely identified; releases are never modified, only superseded.

## Why it matters

Blurring these stages leads to untraceable deployments where "what is running?" cannot be answered confidently. Immutable releases enable rollback (activate an old release), auditability (every running instance maps to a known artifact), and reproducibility (the same artifact runs in staging and production).

## Violations to detect

- Modifying code or config on a running server (SSH and edit in place)
- No distinct build artifact — code deployed directly from version control at runtime
- Release bundles that include environment-specific config baked in (instead of injected at release time)
- No release identifier — inability to determine which version is currently running

## Good practice

- Use a CI/CD pipeline: build once → produce an immutable artifact (Docker image, JAR, binary) → combine with config at release time → run
- Tag every release with a version or commit SHA; store release history
- Automate rollback by activating a previous release artifact

## Sources

- Wiggins, Adam. *The Twelve-Factor App*. Heroku, 2011. https://12factor.net/build-release-run
