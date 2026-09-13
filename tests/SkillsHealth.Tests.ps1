$ErrorActionPreference = 'Stop'
$script:Passed = 0
$script:Failed = 0

function Assert-True([bool]$Condition, [string]$Message) {
    if ($Condition) { $script:Passed++; Write-Host "PASS: $Message" -ForegroundColor Green }
    else { $script:Failed++; Write-Host "FAIL: $Message" -ForegroundColor Red }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$auditScript = Join-Path $repoRoot 'scripts\Test-SkillsHealth.ps1'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("skills-health-tests-" + [guid]::NewGuid().ToString('N'))

try {
    $skillsRoot = Join-Path $testRoot 'skills'
    $good = Join-Path $skillsRoot 'good-skill'
    $broken = Join-Path $skillsRoot 'broken-skill'
    New-Item -ItemType Directory -Path $good, $broken -Force | Out-Null
    Set-Content (Join-Path $good 'SKILL.md') "---`nname: good-skill`n---`n[Guide](guide.md)" -Encoding utf8NoBOM
    $guideContent = @'
# Guide

```markdown
[Example](missing-example.md)
```
'@
    Set-Content (Join-Path $good 'guide.md') $guideContent -Encoding utf8NoBOM
    Set-Content (Join-Path $broken 'SKILL.md') "---`nname: broken-skill`n---`n[Missing](missing.md)" -Encoding utf8NoBOM

    $badResult = & $auditScript -SkillRoots $skillsRoot -ExpectedCount 2 -RuntimeRequirements @{} -Json | ConvertFrom-Json
    Assert-True ($badResult.summary.brokenReferences -eq 1) 'Broken relative Markdown reference is reported'
    Assert-True (-not $badResult.healthy) 'Broken reference makes the audit unhealthy'

    Set-Content (Join-Path $broken 'missing.md') '# Present' -Encoding utf8NoBOM
    $goodResult = & $auditScript -SkillRoots $skillsRoot -ExpectedCount 2 -RuntimeRequirements @{ 'good-skill' = @('pwsh') } -Json | ConvertFrom-Json
    Assert-True ($goodResult.summary.skills -eq 2) 'Every direct Skill directory is counted'
    Assert-True ($goodResult.summary.brokenReferences -eq 0) 'Existing relative Markdown references pass'
    Assert-True ($goodResult.healthy) 'Complete fixture with available runtime is healthy'

    $missingRuntime = & $auditScript -SkillRoots $skillsRoot -ExpectedCount 2 -RuntimeRequirements @{ 'good-skill' = @('command-that-does-not-exist-7f3b') } -Json | ConvertFrom-Json
    Assert-True ($missingRuntime.summary.missingCommands -eq 1) 'Missing runtime command is reported'
    Assert-True (-not $missingRuntime.healthy) 'Missing runtime command makes the audit unhealthy'
}
finally {
    if ($testRoot.StartsWith([IO.Path]::GetTempPath()) -and (Test-Path $testRoot)) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}

if ($script:Failed) { throw "$script:Failed assertion(s) failed; $script:Passed passed." }
Write-Host "PASS: Skills health tests ($script:Passed assertions)" -ForegroundColor Green
