# INFRA-MINIMIZE-IMAGE-LAYERS - Minimize image size and layers with multi-stage builds and combined RUN instructions

**Layer:** 1
**Categories:** container, performance, infrastructure
**Applies-to:** dockerfile
**Summary:** Use multi-stage builds and combine RUN instructions to minimize container image size and attack surface.

## Principle

Keep container images as small as possible by using multi-stage builds to discard build-time dependencies from the final image, and by combining related `RUN` instructions into a single layer with `&&`. Install only what the application needs at runtime; clean up package manager caches in the same `RUN` instruction that installs packages. Copy dependency manifests before application source so that Docker's layer cache is used effectively and source changes do not invalidate the dependency installation layer.

## Why it matters

Large images slow every stage of the delivery pipeline: longer push and pull times from the registry, higher disk consumption on every node, and a larger attack surface at runtime. Each tool or package left in the final image is a potential vulnerability and a capability handed to an attacker who gains code execution. Development tools (compilers, debuggers, build systems) have no place in a production runtime image. Multi-stage builds are the primary mechanism for cleanly separating build and runtime environments without writing complex cleanup scripts.

## Violations to detect

- Sequential separate `RUN apt-get install`, `RUN apk add`, or `RUN yum install` instructions that could be combined into a single layer
- `RUN apt-get update && apt-get install -y …` without `rm -rf /var/lib/apt/lists/*` in the same instruction - leaves the package manager cache in the layer
- No multi-stage build pattern (`FROM … AS builder`) when a compilation or install step produces artefacts that are then copied to the runtime image
- `COPY . .` or `ADD . .` executed before dependency installation steps - busts the layer cache on every source change, causing slow, wasteful rebuilds
- Build tools (`gcc`, `make`, `git`, `curl`, `wget`, test runners, linters) present in the final runtime stage

## Inspection

- `grep -rnE '^RUN\s+apt-get\s+install' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | MEDIUM | Separate apt-get install RUN instructions - consider combining and purging cache in a single layer
- `grep -rnE '^COPY \. \.' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | LOW | Copying all source before dependency install may bust the layer cache unnecessarily

## Good practice

- Use multi-stage builds: `FROM golang:1.22 AS builder` → compile, then `FROM gcr.io/distroless/static:nonroot` → copy binary only
- Combine all related package operations in a single `RUN`: `RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*`
- Copy dependency manifests first, then install, then copy application source - so source-file changes do not invalidate the dependency cache layer
- Use distroless, scratch, or minimal Alpine base images for the final runtime stage to minimise the attack surface
- Inspect layer sizes with `docker history <image>` or `dive` before pushing to a registry

## Sources

- Docker Inc. "Best practices for writing Dockerfiles - Minimize the number of layers." https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#minimize-the-number-of-layers (accessed 2026-03-22).
- Docker Inc. "Use multi-stage builds." https://docs.docker.com/build/building/multi-stage/ (accessed 2026-03-22).
- Google. "Distroless container images." https://github.com/GoogleContainerTools/distroless (accessed 2026-03-22).
