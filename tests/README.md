# tests

Regression tests for `.principles` tooling.

| File | Description |
|---|---|
| [`check-audit-gates.sh`](check-audit-gates.sh) | Verifies audit gate markers (Phases 8–10) exist in all audit command files (Linux/macOS) |
| [`check-audit-gates.ps1`](check-audit-gates.ps1) | Same check for Windows PowerShell |

Run: `bash tests/check-audit-gates.sh` (also executed by CI via `.github/workflows/audit-gates.yml`).
