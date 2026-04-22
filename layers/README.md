# layers

Artifact-type stack definitions. Each subdirectory is a stack; each stack has up to three layer files that define which principles activate automatically based on artifact type and detected context.

| Path | Description |
|---|---|
| [`artifact-types.yaml`](artifact-types.yaml) | Master type registry: maps file extensions/patterns to artifact types; defines universal principles active on all types |
| [`code/`](code/) | Source code stack (Layer 1–3) |
| [`config/`](config/) | Configuration stack |
| [`docs/`](docs/) | Documentation stack |
| [`infra/`](infra/) | Infrastructure-as-Code stack |
| [`pipeline/`](pipeline/) | CI/CD pipeline stack |
| [`schema/`](schema/) | Schema stack |
