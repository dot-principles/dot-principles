# INFRA-NON-ROOT-CONTAINER — Containers must not run as root

**Layer:** 1
**Categories:** security, container, infrastructure
**Applies-to:** dockerfile, kubernetes
**Summary:** Every container must switch to a dedicated non-root user with the USER directive before runtime.

## Principle

Every container must run as a non-root user. Define a dedicated, unprivileged user in the Dockerfile with the `USER` directive and ensure that user owns only the files it needs to operate. Running containers as root grants the process the full privileges of the host's root user if a container escape vulnerability is exploited, turning a container compromise into a host compromise.

## Why it matters

A container running as root means that any code-execution vulnerability inside the container — a deserialization bug, a path traversal, a supply-chain compromise in a dependency — immediately grants an attacker root-level access within the container. If a container escape vulnerability exists in the runtime, root inside the container translates to root on the host. Defence-in-depth requires that even a fully compromised container gives an attacker as little privilege as possible. CIS Docker Benchmark Section 5.1 mandates non-root containers.

## Violations to detect

- No `USER` directive in a Dockerfile — container runs as root by default
- `USER root` in any Dockerfile stage, including intermediate stages, without a subsequent `USER` directive that drops privileges before the final stage
- `runAsNonRoot: false` or `runAsUser: 0` in a Kubernetes Pod security context
- Absence of `securityContext.runAsNonRoot: true` in Kubernetes Deployment or Pod specs that serve user traffic
- `docker run` or `docker-compose` service definitions that do not set a non-root user and rely on the base image default

## Inspection

- `grep -rnE '^USER\s+root\s*$' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | USER root directive — container runs as root
- `grep -rn 'runAsUser:\s*0' --include="*.yaml" --include="*.yml" $TARGET` | HIGH | Kubernetes pod security context running as UID 0 (root)

## Good practice

- Create a dedicated non-root user in the Dockerfile: `RUN groupadd -r appuser && useradd -r -g appuser appuser`
- Switch to that user with `USER appuser` as late as possible — after all root-required setup (package installation, file ownership changes) is complete
- Set `securityContext.runAsNonRoot: true` and `securityContext.runAsUser: <uid>` in all Kubernetes Pod specs
- Add `allowPrivilegeEscalation: false` and `capabilities: {drop: [ALL]}` in Kubernetes security contexts to further restrict privilege
- Prefer base images with a pre-created non-root user (e.g., `node:20-alpine` provides the `node` user; `nginx:alpine` provides the `nginx` user) to avoid manually managing user setup

## Sources

- CIS. "CIS Docker Benchmark v1.6.0." Center for Internet Security, 2023. Section 5.1. https://www.cisecurity.org/benchmark/docker (accessed 2026-03-22).
- OWASP. "Docker Security Cheat Sheet — Rule 2 — Set a user." https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html (accessed 2026-03-22).
- Docker Inc. "Best practices for writing Dockerfiles — USER." https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user (accessed 2026-03-22).
