# INFRA-NO-SECRETS-IN-IMAGE - Secrets must not be baked into image layers

**Layer:** 1
**Categories:** security, container, infrastructure
**Applies-to:** dockerfile
**Summary:** Never pass secrets via ENV, ARG, COPY, or ADD in Dockerfiles; use BuildKit secret mounts instead.

## Principle

Secrets - API keys, passwords, tokens, certificates, private keys - must never be passed into a Dockerfile via `ENV`, `ARG`, `COPY`, or `ADD` in a way that persists them in an image layer. Docker layers are permanent: even if a secret is deleted in a subsequent `RUN` instruction, it remains accessible in the image history and can be extracted with `docker history` or by unpacking the layer tarball directly. Use Docker BuildKit's `--mount=type=secret` to pass secrets to build steps without writing them to any layer.

## Why it matters

Every image layer is an immutable snapshot of the filesystem at that point in the build. Running `RUN rm -f /app/.env` does not remove `.env` from the layer created by `COPY .env /app/.env`; it only adds a new layer that marks the file as deleted. Anyone with access to the image - registry users, CI operators, or an attacker who obtains the image tarball - can retrieve the secret from earlier layers using `docker save` and standard tar tooling. Pushed images may be cached, mirrored, or logged; secrets baked into layers propagate widely and silently. `ARG` values are equally dangerous because they appear verbatim in `docker history --no-trunc`.

## Violations to detect

- `COPY .env` or `ADD .env` copying a secrets file into any Dockerfile stage
- `ENV API_KEY=…`, `ENV PASSWORD=…`, `ENV SECRET=…`, or similar hardcoded credential assignments in a Dockerfile
- `ARG API_KEY`, `ARG PASSWORD`, `ARG TOKEN` used and then referenced in a `RUN` or `ENV` instruction without BuildKit `--mount=type=secret` - ARG values appear in `docker history`
- A multi-stage build that copies a secrets file into an intermediate stage without using BuildKit secret mounts - the intermediate stage's layers are still embedded in the final image manifest
- `RUN echo "password" > /etc/app/config` or equivalent credential-baking in a RUN instruction

## Inspection

- `grep -rnE '^ENV\s+\S*(PASSWORD|SECRET|KEY|TOKEN|CREDENTIAL)\s*=' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | Secret-looking ENV variable hardcoded in Dockerfile
- `grep -rnE '^COPY\s+\.env(\s|$)' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | .env file copied into image layer
- `grep -rnE '^ARG\s+\S*(PASSWORD|SECRET|KEY|TOKEN)' --include="Dockerfile" --include="Dockerfile.*" $TARGET` | HIGH | Secret-looking ARG - verify not exposed via docker history

## Good practice

- Use BuildKit secret mounts to pass secrets to build steps without writing them to any layer: `RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm install`
- Never use `ARG` for secrets; ARG values are recorded verbatim in `docker history --no-trunc`
- Fetch secrets from a secrets manager (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault) at container startup via the entrypoint, not at image build time
- Add `.env`, `*.pem`, `credentials.json`, `*.key`, and similar files to `.dockerignore` so they are never sent to the Docker build context
- Scan images for embedded secrets before pushing to a registry using tools such as `truffleHog`, `detect-secrets`, or `docker scout`

## Sources

- CIS. "CIS Docker Benchmark v1.6.0." Center for Internet Security, 2023. Section 4.10. https://www.cisecurity.org/benchmark/docker (accessed 2026-03-22).
- OWASP. "Docker Security Cheat Sheet - Rule 4 - Do not leak sensitive information to Docker." https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html (accessed 2026-03-22).
- Docker Inc. "Build secrets." https://docs.docker.com/build/building/secrets/ (accessed 2026-03-22).
