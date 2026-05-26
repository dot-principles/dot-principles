# OWASP-02-CRYPTOGRAPHIC-FAILURES - Cryptographic Failures

**Layer:** 3 (risk-elevated)
**Categories:** security, cryptography, data-protection
**Applies-to:** all
**Summary:** Use strong, current cryptographic algorithms with managed keys for all sensitive data in transit and at rest.

## Principle

Protect sensitive data in transit and at rest using strong, up-to-date cryptographic algorithms and proper key management. Cryptographic failures occur when data that requires confidentiality is transmitted or stored without adequate protection, or when weak or broken algorithms are used.

## Why it matters

Cryptographic failures expose passwords, credit card numbers, health records, and personal data to attackers. Weak algorithms (MD5, SHA-1, DES, RC4) or implementation errors (hardcoded keys, insufficient key lengths, missing certificate validation) make encryption trivially bypassable.

## Violations to detect

- Sensitive data transmitted over HTTP instead of HTTPS
- Passwords stored as plain text or with weak hashing algorithms (MD5, SHA-1, unsalted SHA-256)
- Symmetric encryption keys hardcoded in source code
- Disabled TLS certificate validation in HTTP clients
- Use of deprecated algorithms: DES, 3DES, RC4, MD5, SHA-1 for security purposes
- Insufficient randomness: using `Math.random()` or predictable seeds for security tokens

## Good practice

- Use TLS 1.2+ for all data in transit; enforce HSTS
- Hash passwords with bcrypt, scrypt, or Argon2 with appropriate work factors
- Use authenticated encryption (AES-GCM, ChaCha20-Poly1305) for data at rest
- Manage keys outside the application using a secrets manager or HSM
- Do not implement cryptographic algorithms yourself - use vetted libraries

## Sources

- OWASP Foundation. "A02:2021 - Cryptographic Failures." *OWASP Top 10*, 2021. https://owasp.org/Top10/A02_2021-Cryptographic_Failures/
