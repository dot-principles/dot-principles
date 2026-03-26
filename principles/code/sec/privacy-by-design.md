# CODE-SEC-PRIVACY-BY-DESIGN — Embed privacy into the design from the start

**Layer:** 2 (contextual)
**Categories:** security, privacy, data-protection
**Applies-to:** all
**Summary:** Collect only required personal data, retain it minimally, and make privacy-protective behavior the default.

## Principle

Privacy must be a first-class design constraint, not a compliance checkbox applied after delivery. Collect only the personal data required for the stated purpose, retain it only for as long as necessary, give users meaningful control over their own data, and design systems so that privacy-protective behaviour is the default — not an opt-in.

## Why it matters

Systems designed without privacy in mind accumulate excessive data, create regulatory exposure under GDPR, CCPA, and HIPAA, and amplify the harm to users when breaches occur. Retroactively removing data from a system built to collect everything is expensive, incomplete, and often architecturally impossible. Data never collected cannot be breached, cannot be subpoenaed, and cannot be misused.

## Violations to detect

- Request or response bodies logged verbatim when they may contain PII (names, emails, passwords, payment details, health data)
- No defined data retention policy — records accumulate indefinitely without deletion or anonymisation
- Collecting data fields "in case they are useful later" with no declared processing purpose
- User account deletion that leaves personal data intact in backup systems, analytics pipelines, or derived tables
- Analytics or telemetry events that include user identifiers or device fingerprints beyond what is necessary for the stated measurement
- Absence of a mechanism for users to export or delete their personal data

## Good practice

- Apply data minimisation at design time: for each field collected, document the processing purpose; if no purpose exists, do not collect it
- Mask or redact PII before logging; use structured log fields with explicit allow-lists rather than serialising entire objects
- Define retention periods in the schema or storage layer and enforce them automatically through scheduled deletion jobs
- Separate personal data from analytical data at the schema level so analytics queries cannot access raw PII
- Build user data export and deletion flows into the initial design, not as afterthoughts
- Default all new data-collection features to off; require an explicit opt-in for anything beyond strict operational necessity

## Sources

- Cavoukian, Ann. "Privacy by Design: The 7 Foundational Principles." Information and Privacy Commissioner of Ontario, 2009. https://www.ipc.on.ca/wp-content/uploads/resources/7foundationalprinciples.pdf
- ISO/IEC 29101:2018. "Information technology — Security techniques — Privacy architecture framework." ISO, 2018.
- GDPR Article 25. "Data protection by design and by default." Regulation (EU) 2016/679. https://gdpr-info.eu/art-25-gdpr/
