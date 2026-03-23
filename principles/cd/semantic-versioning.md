# CD-SEMANTIC-VERSIONING — Version numbers must communicate the nature of changes

**Layer:** 1
**Categories:** release-management, api-design, compatibility, continuous-delivery
**Applies-to:** all

## Principle

Version numbers follow the `MAJOR.MINOR.PATCH` format (Semantic Versioning 2.0.0): increment `MAJOR` for breaking changes, `MINOR` for new backward-compatible features, and `PATCH` for backward-compatible bug fixes. Pre-release identifiers and build metadata are appended with `-` and `+` respectively. The version communicates a contract to consumers: a version bump tells them whether upgrading is safe without reading the diff.

## Why it matters

When version numbers are arbitrary or increment only by date/build number, consumers cannot determine upgrade risk without reading every commit. A `MAJOR` bump signals "there may be breakage — review before upgrading". A `PATCH` bump signals "this is safe". This contract is the foundation of automated dependency management (`^`, `~`, compatible ranges). Violating it erodes trust and forces consumers to pin exact versions defensively, losing the benefit of automatic patch updates.

## Violations to detect

- `0.x` versions for public-facing production APIs or libraries (signals the contract is undefined)
- Version strings that do not match `MAJOR.MINOR.PATCH` (dates, hashes, build numbers used as versions)
- A CHANGELOG with no entries, stub entries, or entries that do not distinguish breaking from non-breaking changes
- A `MINOR` or `PATCH` bump that introduces a breaking API change (removals, renames, signature changes)
- Dependencies pinned to exact versions (`1.2.3` instead of `^1.2.3`) suggesting past version contract violations
- Version never incrementing between releases — same version deployed to multiple environments

## Inspection

- `grep -rnE '"version"\s*:\s*"0\.' --include="package.json" $TARGET` | MEDIUM | Production package still on 0.x — semver contract undefined
- `grep -rnE '^version\s*=\s*"0\.' --include="*.toml" --include="*.cfg" $TARGET` | MEDIUM | Package on 0.x — semver guarantees not yet made
- `grep -rnE '"version"\s*:\s*"[0-9]{8}|"version"\s*:\s*"[0-9]+\.[0-9]+-build' --include="package.json" $TARGET` | HIGH | Date or build-number used as version — not semver
- `grep -rnE 'CHANGELOG|CHANGES|HISTORY' $TARGET -l` | INFO | Verify changelog exists and covers all releases

## Good practice

```
1.0.0          Initial stable release
1.0.1          Bug fix — safe to upgrade (PATCH)
1.1.0          New feature, backward-compatible (MINOR)
2.0.0          Breaking change — consumers must review (MAJOR)
2.1.0-beta.1   Pre-release of next feature
```

- Adopt a conventional commit convention (`fix:`, `feat:`, `feat!:`) to enable automated version bumping and CHANGELOG generation
- Use tooling (`semantic-release`, `release-please`, `standard-version`) to derive the version bump from commit messages and prevent manual errors
- Document breaking changes prominently in the CHANGELOG under a `### Breaking Changes` heading
- Never use the same version number in different environments — every deployed artefact should carry a unique, immutable version
- For internal libraries, `1.0.0` is an explicit commitment to semver; `0.x` is pre-stable and allows breaking changes in MINOR

## Sources

- Preston-Werner, Tom. *Semantic Versioning 2.0.0*. https://semver.org
- Conventional Commits specification. https://www.conventionalcommits.org
