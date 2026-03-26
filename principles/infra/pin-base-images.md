# INFRA-PIN-BASE-IMAGES — Pin base images to a specific digest or version tag; never use `latest`

**Layer:** 1
**Categories:** security, container, supply-chain, infrastructure
**Applies-to:** dockerfile
**Summary:** Pin every FROM instruction to a specific digest or full version tag; never use mutable tags like latest.

## Principle

Every `FROM` instruction in a Dockerfile must reference a specific, immutable image version — a digest (`sha256:…`) for the strongest guarantee, or at minimum a full `major.minor.patch` version tag. Never use `:latest` or an unqualified image name without a tag. Mutable tags do not uniquely identify an image; the content they point to can change silently between builds, introducing uncontrolled changes to the runtime environment.

## Why it matters

Using `FROM node:latest` means each build pulls whatever the upstream maintainer last pushed under that tag. A dependency update, a base OS upgrade, or a supply-chain compromise can change the image silently between two builds from the same Dockerfile. The change may not manifest until the affected image reaches production. Pinning to a digest ensures every build uses an identical filesystem, which is a prerequisite for reproducible builds and supply-chain verification (SLSA Level 2+). CIS Docker Benchmark Section 4.1 requires that only authorised base images are used.

## Violations to detect

- `FROM image:latest` or `FROM image` (no tag) in any Dockerfile stage, including intermediate build stages
- `FROM image:<tag>` where the tag is a moving target such as `stable`, `current`, `lts`, `mainline`, or a major-only version like `node:20` without a minor and patch component
- Base image tag updated by an automated tool (Dependabot, Renovate) but the digest not verified or committed alongside the tag
- `ARG BASE_IMAGE_TAG` used to pass the tag at build time without a corresponding digest pin

## Inspection

- `grep -rnE '^FROM\s+\S+:latest(\s|$)' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | Base image pinned to mutable latest tag
- `grep -rnE '^FROM\s+[^@\s]+$' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | Base image has no tag and no digest

## Good practice

- Pin to a digest for maximum reproducibility: `FROM node:20.11.0-alpine3.19@sha256:abc123…`
- If digest pinning is impractical, use a full `major.minor.patch` version tag and commit to regular, reviewed updates via a dependency-update tool
- Use `docker buildx imagetools inspect <image:tag>` or `crane digest <image:tag>` to retrieve the digest of a tagged image
- Enable Renovate or Dependabot to automate digest updates so security patches are adopted in a reviewable, auditable way
- Scan base images for vulnerabilities in CI (Trivy, Grype, Snyk Container) so all updates are vetted before reaching production

## Sources

- CIS. "CIS Docker Benchmark v1.6.0." Center for Internet Security, 2023. Section 4.1. https://www.cisecurity.org/benchmark/docker (accessed 2026-03-22).
- Docker Inc. "Best practices for writing Dockerfiles — FROM." https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#from (accessed 2026-03-22).
- OpenSSF. "SLSA: Supply-chain Levels for Software Artifacts." v1.0, 2023. https://slsa.dev/spec/v1.0/requirements (accessed 2026-03-22).
