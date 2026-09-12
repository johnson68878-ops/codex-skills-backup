param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex'),
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$PluginCacheRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'SkillsBackup.psm1') -Force

$repository = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$sourceSkills = Join-Path $CodexHome 'skills'
$sourceSkills = (Resolve-Path -LiteralPath $sourceSkills).Path
$snapshotRoot = Join-Path $repository 'skills'
$expectedSnapshot = [IO.Path]::GetFullPath((Join-Path $repository 'skills'))
if ([IO.Path]::GetFullPath($snapshotRoot) -ne $expectedSnapshot) {
    throw 'Unexpected snapshot path.'
}

if (Test-Path -LiteralPath $snapshotRoot) {
    Remove-Item -LiteralPath $snapshotRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $snapshotRoot -Force | Out-Null

$discovered = @(Get-SkillDirectories -Root $sourceSkills -Exclude @('.system'))
$snapshot = @(Export-SkillsSnapshot -SourceRoot $sourceSkills -DestinationRoot $snapshotRoot -Exclude @('.system'))
if ($snapshot.Count -ne $discovered.Count) {
    $blocked = foreach ($skill in $discovered) {
        $findings = @(Test-SkillSecurity -Path $skill.FullName)
        if ($findings.Count -gt 0) { $skill.Name }
    }
    throw "Security scan blocked Skills: $($blocked -join ', ')"
}

$portableSkills = @($snapshot | Sort-Object name | ForEach-Object {
    [pscustomobject][ordered]@{
        name = $_.name
        source = "skills/$($_.name)"
        fileCount = $_.fileCount
        sizeBytes = $_.sizeBytes
        sha256 = $_.sha256
    }
})

$manifestRoot = Join-Path $repository 'manifests'
New-Item -ItemType Directory -Path $manifestRoot -Force | Out-Null
$personalManifest = [pscustomobject][ordered]@{ schemaVersion = 1; skills = $portableSkills }
$personalManifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $manifestRoot 'personal-skills.json') -Encoding utf8NoBOM

if (-not $PluginCacheRoot) {
    $PluginCacheRoot = Join-Path $CodexHome 'plugins\cache'
}
$pluginSkills = @()
if (Test-Path -LiteralPath $PluginCacheRoot) {
    $pluginBase = (Resolve-Path -LiteralPath $PluginCacheRoot).Path
    $pluginSkills = @(Get-ChildItem -LiteralPath $pluginBase -Filter SKILL.md -File -Recurse -Force | ForEach-Object {
        [pscustomobject][ordered]@{
            name = $_.Directory.Name
            relativePath = [IO.Path]::GetRelativePath($pluginBase, $_.FullName).Replace('\', '/')
        }
    } | Sort-Object name, relativePath)
}
$pluginManifest = [pscustomobject][ordered]@{ schemaVersion = 1; note = 'Inventory only; reconnect plugins in Codex App.'; skills = $pluginSkills }
$pluginManifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $manifestRoot 'plugin-skills.json') -Encoding utf8NoBOM

Write-Output "Backed up $($portableSkills.Count) personal Skills."
Write-Output "Inventoried $($pluginSkills.Count) plugin-provided Skills."
