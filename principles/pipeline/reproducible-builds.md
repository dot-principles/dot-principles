# PIPELINE-REPRODUCIBLE-BUILDS - Ensure builds produce identical outputs from identical inputs

**Layer:** 1 (universal)
**Categories:** reliability, pipeline, supply-chain
**Applies-to:** pipeline
**Summary:** Pin all dependency versions and build tool images so identical inputs always produce identical artifacts.

## Principle

A pipeline build is reproducible when the same source code, dependency set, and build toolchain produce a bit-for-bit identical artifact every time, regardless of when or where the build runs. Achieve this by pinning dependency versions in lockfiles, pinning build tool versions, avoiding network fetches during compilation, and eliminating reliance on ambient machine state such as timestamps, locale, or filesystem ordering.

## Why it matters

Non-reproducible builds undermine every downstream guarantee. If rebuilding from the same commit produces a different binary, you cannot verify that what was tested is what ships. Attackers can exploit non-determinism to inject code that only appears in certain build environments. Debugging production issues becomes guesswork when the artifact cannot be reliably recreated from source. Reproducibility is also a prerequisite for SLSA Level 3 provenance.

## Violations to detect

- `npm install` instead of `npm ci` or `yarn install --frozen-lockfile` in build steps - allows dependency resolution to drift
- `pip install -r requirements.txt` without `--require-hashes` or `--no-deps` and no lockfile - allows transitive dependency drift
- Missing lockfiles (`package-lock.json`, `yarn.lock`, `Cargo.lock`, `go.sum`, `poetry.lock`, `Pipfile.lock`) in the repository
- Build steps that download tools at runtime (`curl | bash`, `wget` for build tools) without version pinning or checksum verification
- Use of `latest` tag for build tool images: `image: node:latest`, `image: gradle:latest`
- Timestamps, random UUIDs, or build-machine hostnames embedded in the artifact (e.g., `BUILD_TIME=$(date)` baked into metadata)
- `go install` without `@v<version>` - installs whatever is in the module cache or latest

## Inspection

- `grep -rnE 'npm install\b' --include="*.yml" --include="*.yaml" --include="Jenkinsfile" --include="Dockerfile" $TARGET` | HIGH | npm install instead of npm ci
- `grep -rnE 'image:\s+\S+:latest' --include="*.yml" --include="*.yaml" $TARGET` | MEDIUM | Build image pinned to latest tag
- `grep -rnE 'curl.*\|\s*(ba)?sh' --include="*.yml" --include="*.yaml" --include="Jenkinsfile" $TARGET` | HIGH | Piping curl to shell without verification

## Good practice

- Use `npm ci`, `yarn install --frozen-lockfile`, or `pnpm install --frozen-lockfile` - these install exactly what the lockfile specifies and fail if it is out of sync
- Pin build tool images to a digest: `image: node@sha256:abc123...` rather than a mutable tag
- Vendor dependencies or use a private artifact proxy so builds do not depend on external registries at build time
- Avoid embedding timestamps or non-deterministic values in artifacts; use `SOURCE_DATE_EPOCH` where supported
- Commit all lockfiles to version control; treat lockfile drift as a build failure
- Verify checksums of any tools downloaded during the build; prefer pre-built images with tools already installed

## Sources

- Humble, Jez, and David Farley. *Continuous Delivery*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. Chapter 5.
- OpenSSF. "SLSA: Supply-chain Levels for Software Artifacts." v1.0, 2023. https://slsa.dev/spec/v1.0/requirements (accessed 2026-03-22).
- The Reproducible Builds Project. "Reproducible Builds." https://reproducible-builds.org (accessed 2026-03-22).
