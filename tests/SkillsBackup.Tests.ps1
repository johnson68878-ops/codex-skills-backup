$ErrorActionPreference = 'Stop'

$script:Passed = 0
$script:Failed = 0

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) {
        $script:Failed++
        Write-Host "FAIL: $Message" -ForegroundColor Red
        return
    }
    $script:Passed++
    Write-Host "PASS: $Message" -ForegroundColor Green
}

function Assert-Equal {
    param($Actual, $Expected, [string]$Message)
    Assert-True -Condition ($Actual -eq $Expected) -Message "$Message (expected '$Expected', got '$Actual')"
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$modulePath = Join-Path $repoRoot 'scripts\SkillsBackup.psm1'
Import-Module $modulePath -Force

$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("codex-skills-backup-tests-" + [guid]::NewGuid().ToString('N'))
$sourceRoot = Join-Path $testRoot 'source'
$copyRoot = Join-Path $testRoot 'copy'

try {
    New-Item -ItemType Directory -Path $sourceRoot, $copyRoot -Force | Out-Null

    $valid = Join-Path $sourceRoot 'valid-skill'
    $system = Join-Path $sourceRoot '.system'
    $missing = Join-Path $sourceRoot 'missing-skill-file'
    $risky = Join-Path $sourceRoot 'risky-skill'
    New-Item -ItemType Directory -Path $valid, $system, $missing, $risky -Force | Out-Null

    Set-Content -LiteralPath (Join-Path $valid 'SKILL.md') -Value "---`nname: valid-skill`n---`n# Valid" -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $valid 'notes.txt') -Value 'ordinary instructions' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $system 'SKILL.md') -Value "---`nname: system`n---" -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $risky 'SKILL.md') -Value "---`nname: risky-skill`n---" -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $risky '.env') -Value 'SECRET=value' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $risky 'private.txt') -Value '-----BEGIN PRIVATE KEY-----' -Encoding utf8NoBOM

    $skills = @(Get-SkillDirectories -Root $sourceRoot -Exclude @('.system'))
    Assert-Equal -Actual $skills.Count -Expected 2 -Message 'Discovery includes only direct child directories containing SKILL.md and excludes .system'
    Assert-True -Condition ($skills.Name -contains 'valid-skill') -Message 'Discovery includes valid-skill'
    Assert-True -Condition ($skills.Name -contains 'risky-skill') -Message 'Discovery leaves security decisions to the scanner'

    $safeFindings = @(Test-SkillSecurity -Path $valid)
    Assert-Equal -Actual $safeFindings.Count -Expected 0 -Message 'Security scan accepts ordinary Skill content'

    $riskyFindings = @(Test-SkillSecurity -Path $risky)
    Assert-True -Condition (($riskyFindings.Kind -contains 'ForbiddenFileName') -and ($riskyFindings.Kind -contains 'SecretContent')) -Message 'Security scan detects forbidden filenames and private-key content'

    $before = Get-DirectoryDigest -Path $valid
    Copy-Item -LiteralPath $valid -Destination (Join-Path $copyRoot 'valid-skill') -Recurse
    $after = Get-DirectoryDigest -Path (Join-Path $copyRoot 'valid-skill')
    Assert-Equal -Actual $after -Expected $before -Message 'Directory digest is stable after copying'

    $snapshotRoot = Join-Path $testRoot 'snapshot'
    $manifest = @(Export-SkillsSnapshot -SourceRoot $sourceRoot -DestinationRoot $snapshotRoot -Exclude @('.system') -WarningAction SilentlyContinue)
    Assert-Equal -Actual $manifest.Count -Expected 1 -Message 'Snapshot exports only security-approved Skills'
    Assert-Equal -Actual $manifest[0].name -Expected 'valid-skill' -Message 'Snapshot manifest names the exported Skill'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $snapshotRoot 'valid-skill\SKILL.md')) -Message 'Snapshot contains the Skill files'

    $updateScript = Join-Path $repoRoot 'scripts\update-backup.ps1'
    $installScript = Join-Path $repoRoot 'scripts\install.ps1'
    $verifyScript = Join-Path $repoRoot 'scripts\verify.ps1'
    $fixtureRepo = Join-Path $testRoot 'repository'
    $fixtureCodex = Join-Path $testRoot 'source-codex'
    $fixtureSkills = Join-Path $fixtureCodex 'skills'
    $pluginCache = Join-Path $fixtureCodex 'plugins\cache\sample-plugin\1.2.3\skills\plugin-skill'
    New-Item -ItemType Directory -Path $fixtureRepo, $fixtureSkills, $pluginCache -Force | Out-Null

    Copy-Item -LiteralPath $valid -Destination (Join-Path $fixtureSkills 'valid-skill') -Recurse
    Set-Content -LiteralPath (Join-Path $pluginCache 'SKILL.md') -Value "---`nname: plugin-skill`n---" -Encoding utf8NoBOM
    $stale = Join-Path $fixtureRepo 'skills\stale-skill'
    New-Item -ItemType Directory -Path $stale -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $stale 'SKILL.md') -Value 'stale' -Encoding utf8NoBOM

    & $updateScript -CodexHome $fixtureCodex -RepositoryRoot $fixtureRepo -PluginCacheRoot (Join-Path $fixtureCodex 'plugins\cache')
    Assert-True -Condition (-not (Test-Path -LiteralPath $stale)) -Message 'Update removes stale snapshot Skills'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $fixtureRepo 'manifests\personal-skills.json')) -Message 'Update writes personal Skill manifest'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $fixtureRepo 'manifests\plugin-skills.json')) -Message 'Update writes plugin Skill inventory'

    $personalJson1 = Get-Content -LiteralPath (Join-Path $fixtureRepo 'manifests\personal-skills.json') -Raw
    & $updateScript -CodexHome $fixtureCodex -RepositoryRoot $fixtureRepo -PluginCacheRoot (Join-Path $fixtureCodex 'plugins\cache')
    $personalJson2 = Get-Content -LiteralPath (Join-Path $fixtureRepo 'manifests\personal-skills.json') -Raw
    Assert-Equal -Actual $personalJson2 -Expected $personalJson1 -Message 'Repeated update writes deterministic personal manifest JSON'

    $personalManifest = $personalJson1 | ConvertFrom-Json
    Assert-Equal -Actual $personalManifest.skills[0].name -Expected 'valid-skill' -Message 'Personal manifest names the vendored Skill'
    Assert-Equal -Actual $personalManifest.skills[0].source -Expected 'skills/valid-skill' -Message 'Personal manifest contains a portable relative source'
    $pluginManifest = Get-Content -LiteralPath (Join-Path $fixtureRepo 'manifests\plugin-skills.json') -Raw | ConvertFrom-Json
    Assert-Equal -Actual $pluginManifest.skills[0].name -Expected 'plugin-skill' -Message 'Plugin inventory records discovered plugin Skill'

    $targetCodex = Join-Path $testRoot 'target-codex'
    $oldTarget = Join-Path $targetCodex 'skills\valid-skill'
    New-Item -ItemType Directory -Path $oldTarget -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $oldTarget 'SKILL.md') -Value 'old-version' -Encoding utf8NoBOM
    & $installScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex -BackupTimestamp '20260912-120000'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $targetCodex 'skills-backup\20260912-120000\valid-skill\SKILL.md')) -Message 'Install preserves a conflicting destination Skill'
    Assert-Equal -Actual (Get-DirectoryDigest -Path $oldTarget) -Expected $personalManifest.skills[0].sha256 -Message 'Install restores the manifest version'

    $whatIfCodex = Join-Path $testRoot 'whatif-codex'
    & $installScript -RepositoryRoot $fixtureRepo -CodexHome $whatIfCodex -WhatIf
    Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $whatIfCodex 'skills\valid-skill'))) -Message 'Install WhatIf makes no destination changes'

    & $verifyScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex
    Assert-True -Condition $true -Message 'Verify accepts a matching restored Skill'
    Add-Content -LiteralPath (Join-Path $oldTarget 'SKILL.md') -Value 'tampered'
    $verifyDetectedChange = $false
    try {
        & $verifyScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex
    }
    catch {
        $verifyDetectedChange = $true
    }
    Assert-True -Condition $verifyDetectedChange -Message 'Verify rejects a modified restored Skill'

    $falsePositiveSkill = Join-Path $testRoot 'false-positive-skill'
    New-Item -ItemType Directory -Path $falsePositiveSkill -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $falsePositiveSkill 'SKILL.md') -Encoding utf8NoBOM -Value @'
---
name: false-positive-skill
---
spacing token: `--sp-2` 4 / `--sp-3` 8
$token = "phase-status-" + $PID + [Guid]::NewGuid().ToString("N")
maptilersdk.config.apiKey = process.env.REMOTION_MAPTILER_TOKEN as string;
POST https://public-dsn.algolia.net/1/indexes/*/queries?x-algolia-api-key=abcdefghijklmnopqrstuvwx1234567890ABCDEFGHIJKLMNOP
PADDLE_TOKEN_APPLY_URL = "https://aistudio.baidu.com/account/accessToken"
query_tokens = set(bm25.tokenize(query))
'@
    $falsePositiveFindings = @(Test-SkillSecurity -Path $falsePositiveSkill)
    Assert-Equal -Actual $falsePositiveFindings.Count -Expected 0 -Message 'Security scan ignores design tokens, runtime variables, environment references, and public Algolia search keys'

    $genericSecretSkill = Join-Path $testRoot 'generic-secret-skill'
    New-Item -ItemType Directory -Path $genericSecretSkill -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $genericSecretSkill 'SKILL.md') -Encoding utf8NoBOM -Value "---`nname: generic-secret-skill`n---`nAPI_KEY=K9kLm2Np4Qr6St8Uv0Wx2Yz4Ab6Cd8Ef"
    $genericSecretFindings = @(Test-SkillSecurity -Path $genericSecretSkill)
    Assert-True -Condition ($genericSecretFindings.Kind -contains 'SecretContent') -Message 'Security scan still detects an unprefixed high-entropy API key value'

    $additionalRoot = Join-Path $testRoot 'agent-skills'
    $additionalSkill = Join-Path $additionalRoot 'shared-skill'
    New-Item -ItemType Directory -Path $additionalSkill -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $additionalSkill 'SKILL.md') -Value "---`nname: shared-skill`n---`n# Shared" -Encoding utf8NoBOM
    & $updateScript -CodexHome $fixtureCodex -RepositoryRoot $fixtureRepo -AdditionalSkillsRoot $additionalRoot
    $combined = Get-Content (Join-Path $fixtureRepo 'manifests\personal-skills.json') -Raw | ConvertFrom-Json
    Assert-Equal -Actual @($combined.skills).Count -Expected 2 -Message 'Update includes both personal skill roots'
    & $verifyScript -RepositoryRoot $fixtureRepo -CodexHome $fixtureCodex -AdditionalSkillsRoot $additionalRoot
    & $installScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex -BackupTimestamp 'combined'
    & $verifyScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex
    Assert-True -Condition (Test-Path (Join-Path $targetCodex 'skills\shared-skill\SKILL.md')) -Message 'Combined snapshot restores to a single Codex skills directory'

    $beforeDuplicate = Get-Content (Join-Path $fixtureRepo 'manifests\personal-skills.json') -Raw
    Copy-Item -LiteralPath $valid -Destination (Join-Path $additionalRoot 'valid-skill') -Recurse
    $duplicateRejected = $false
    try { & $updateScript -CodexHome $fixtureCodex -RepositoryRoot $fixtureRepo -AdditionalSkillsRoot $additionalRoot }
    catch { $duplicateRejected = $_.Exception.Message -like 'Duplicate Skill names*' }
    Assert-True -Condition $duplicateRejected -Message 'Duplicate source names are rejected'
    Assert-Equal -Actual (Get-Content (Join-Path $fixtureRepo 'manifests\personal-skills.json') -Raw) -Expected $beforeDuplicate -Message 'Rejected source preserves existing manifest'
    & $verifyScript -RepositoryRoot $fixtureRepo -CodexHome $targetCodex
}
finally {
    if ($testRoot.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $testRoot)) {
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}

if ($script:Failed -gt 0) {
    throw "$($script:Failed) assertion(s) failed; $($script:Passed) passed."
}

Write-Host "PASS: SkillsBackup module tests ($($script:Passed) assertions)" -ForegroundColor Green
