# CODE-SEC-STRONG-CRYPTOGRAPHY — Use strong cryptography correctly

**Layer:** 2 (contextual)
**Categories:** security
**Applies-to:** all
**Summary:** Use only established cryptographic algorithms and libraries; never implement custom cryptographic primitives.

## Principle

Use well-established cryptographic algorithms, protocols, and libraries, and configure them properly. Cryptographic failures (A02:2021) occur when sensitive data is not protected at rest or in transit, when weak or obsolete algorithms are used, when keys are poorly managed, or when encryption is applied incorrectly. Never implement custom cryptographic primitives.

## Why it matters

Cryptographic failures expose sensitive data such as passwords, financial records, health information, and personal data. Weak hashing allows credential stuffing, missing TLS enables eavesdropping, and poor key management renders encryption useless. These failures frequently result in regulatory violations and large-scale data breaches.

## Violations to detect

- Use of deprecated algorithms: MD5 or SHA-1 for integrity, DES or 3DES for encryption, RC4, or ECB mode
- Passwords stored with unsalted hashes or fast hash functions (SHA-256 without a work factor)
- Hardcoded encryption keys, API keys, or passwords in source code
- Missing TLS enforcement on connections carrying sensitive data
- Disabled or improperly configured certificate validation
- Random number generation using non-cryptographic PRNGs for security purposes (e.g., `Math.random()`)

## Good practice

- Use AES-256-GCM or ChaCha20-Poly1305 for symmetric encryption; RSA-OAEP or ECDH for asymmetric operations
- Hash passwords with bcrypt, scrypt, or Argon2id with appropriate work factors
- Enforce TLS 1.2 or later for all data in transit; enable HSTS
- Store keys in a secrets manager or hardware security module, never in source code or config files
- Use cryptographically secure random number generators (e.g., `SecureRandom`, `/dev/urandom`, `crypto.getRandomValues`)
- Classify data by sensitivity and apply protection proportional to the classification

## Sources

- OWASP Foundation. "OWASP Top 10:2021 — A02:2021 Cryptographic Failures." https://owasp.org/Top10/A02_2021-Cryptographic_Failures/
