# OWASP-09-LOGGING-FAILURES — Security Logging and Monitoring Failures

**Layer:** 2 (contextual)
**Categories:** security, observability, incident-response
**Applies-to:** all
**Summary:** Log all security-relevant events with full context, aggregate centrally, and alert on anomalous patterns.

## Principle

Log security-relevant events with sufficient detail for forensics and alerting. Monitor logs for attack patterns and alert in time to respond. Without adequate logging and monitoring, breaches go undetected for weeks or months, and forensic investigation after an incident is impossible.

## Why it matters

The average time to detect a breach is measured in months. Attackers rely on this detection gap to exfiltrate data, establish persistence, and cover their tracks. Comprehensive security logging with active monitoring is the primary mechanism for detecting attacks in progress and enabling rapid incident response.

## Violations to detect

- No logging of authentication events (login, logout, failed attempts, password resets)
- No logging of access control failures or authorisation decisions
- Log entries that lack timestamps, user identity, source IP, or request context
- Logs stored only locally on application servers with no central aggregation
- No alerting configured on repeated authentication failures or other anomaly patterns
- Log data containing sensitive values (passwords, session tokens, credit card numbers)

## Good practice

- Log all authentication events, authorisation failures, and data access decisions
- Include: timestamp (UTC), user identity, source IP, resource accessed, outcome
- Aggregate logs centrally (ELK, Splunk, CloudWatch) so they survive individual server compromise
- Configure alerts for: N failed logins in T seconds, access from new geography, privilege escalation attempts
- Protect log integrity: write-once storage, separate credentials for log ingestion vs. read

## Sources

- OWASP Foundation. "A09:2021 – Security Logging and Monitoring Failures." *OWASP Top 10*, 2021. https://owasp.org/Top10/A09_2021-Security_Logging_and_Monitoring_Failures/
