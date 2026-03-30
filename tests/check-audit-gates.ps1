# check-audit-gates.ps1 — Verify that Phase 8–10 gate language is intact in all interactive audit files.
# Run locally before pushing, or via CI on PRs that touch audit/skill files.
# Usage: ./tests/check-audit-gates.ps1 [repo-root]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$AuditFiles = @(
    Join-Path $RepoRoot ".github\skills\audit\SKILL.md"
    Join-Path $RepoRoot ".github\prompts\audit.prompt.md"
    Join-Path $RepoRoot "targets\claude-code\audit.md"
)

# Files that use plain-text output (not ask_user tool) must include the hard-stop phrase.
$PlainTextFiles = @(
    Join-Path $RepoRoot ".github\skills\audit\SKILL.md"
    Join-Path $RepoRoot "targets\claude-code\audit.md"
)

$Errors = 0

function Check-Marker {
    param([string]$File, [string]$Pattern, [string]$Label)
    $content = Get-Content $File -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content -or -not $content.Contains($Pattern)) {
        Write-Host "FAIL [$Label]"
        Write-Host "     File   : $File"
        Write-Host "     Missing: $Pattern"
        $script:Errors++
    }
}

foreach ($file in $AuditFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "FAIL [file-exists] Missing file: $file"
        $Errors++
        continue
    }

    $name = Split-Path -Leaf $file

    Check-Marker $file "## Phase 8"                                    "$name: Phase 8 heading"
    Check-Marker $file "GATE — Requires explicit user approval"        "$name: Phase 8 GATE marker"
    Check-Marker $file "Would you like me to fix these findings"       "$name: Phase 8 fix question"
    Check-Marker $file "Yes, fix them"                                 "$name: Phase 8 Yes choice"
    Check-Marker $file "No, just the report"                          "$name: Phase 8 No choice"
    Check-Marker $file "## Phase 9"                                    "$name: Phase 9 heading"
    Check-Marker $file "## Phase 10"                                   "$name: Phase 10 heading"
}

# Plain-text output files (not using ask_user tool) must include the explicit hard-stop phrase.
foreach ($file in $PlainTextFiles) {
    if (-not (Test-Path $file)) { continue }
    $name = Split-Path -Leaf $file
    Check-Marker $file "End your response here. Do not call any tools" "$name: Phase 8 hard-stop"
}

if ($Errors -eq 0) {
    Write-Host "OK  All Phase 8-10 gate markers verified in $($AuditFiles.Count) files."
    exit 0
} else {
    Write-Host ""
    Write-Host "FAIL $Errors check(s) failed. The audit gate workflow is incomplete."
    exit 1
}
