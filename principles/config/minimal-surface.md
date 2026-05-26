# CONFIG-MINIMAL-SURFACE - Expose only the configuration the application reads

**Layer:** 2 (contextual)
**Categories:** configuration, security, maintainability
**Applies-to:** config
**Summary:** Remove all unused, deprecated, and duplicated configuration keys to minimise the configuration attack surface.

## Principle

A configuration file should contain only the keys the application actively reads and uses. Unused, deprecated, commented-out, and duplicated configuration keys must be removed. A smaller configuration surface means fewer keys to misunderstand, misconfigure, audit, and rotate - and a clearer contract between the config file and the application that consumes it.

## Why it matters

Dead configuration keys create confusion ("is this still active?"), create hidden security exposure (a key for a removed feature may still be read by overlooked code), and make audits harder. OWASP A05 (Security Misconfiguration) identifies unnecessary features and unremediated default configuration as primary misconfiguration sources. Overly large config files are the configuration equivalent of dead code - noise that conceals signal.

## Violations to detect

- Commented-out configuration keys with no explanation of their status (`# old_timeout: 30`)
- Keys present in config that no longer appear anywhere in application source (`grep` finds no reads)
- Framework-generated config templates imported wholesale without removing sections not applicable to the project
- Multiple keys that configure the same thing (legacy key and new key both present, application reads both)
- `TODO: remove` or `deprecated` comments on config keys that have not been removed

## Inspection

- `grep -rn "# TODO\|# DEPRECATED\|# old_\|# unused\|# remove" --include="*.yaml" --include="*.yml" --include="*.toml" --include="*.env" --include="*.properties" $TARGET` | LOW | Potentially unused or deprecated configuration keys

## Good practice

- Remove config keys when the feature they configure is removed from the application; treat this as part of the same PR
- Periodically cross-reference config keys against application source (`grep` for every key name) to confirm each is still read
- Use schema `required` and `optional` annotations to make the contract explicit; remove optional keys that have no corresponding application read
- Document deprecated keys with a removal target version and enforce removal in the schema deprecation lifecycle
- Start from a minimal config and add keys only when the application explicitly needs them, rather than importing a maximal template

## Sources

- OWASP. "A05:2021 - Security Misconfiguration." OWASP Top 10. https://owasp.org/Top10/A05_2021-Security_Misconfiguration/ (accessed 2026-03-22).
- Nygard, Michael T. *Release It! Design and Deploy Production-Ready Software*. 2nd edition. Pragmatic Bookshelf, 2018. ISBN 978-1-68050-239-8. Chapter 5 (Stability Patterns - Configuration).
- Saltzer, Jerome H. & Schroeder, Michael D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE* 63, no. 9 (1975): 1278-1308. (Principle of Economy of Mechanism - minimal attack surface.)
