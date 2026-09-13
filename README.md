# Codex Skills Backup

Private backup of the personal Codex Skills installed on the Windows PC belonging to `johnson68878-ops`.

This repository vendors **53 personal Skills**, collected from `%USERPROFILE%\.codex\skills` (52) and `%USERPROFILE%\.agents\skills` (1). It intentionally excludes `.system`, authentication data, conversations, browser profiles, Codex configuration credentials, and plugin caches. Plugin-provided Skills are listed in `manifests/plugin-skills.json`; reconnect those plugins separately in Codex App because their account permissions and MCP services cannot be restored by copying files. The current Windows machine has passed the local 53-Skill structure and known-command health audit; account-bound integrations are listed in the verification report.

Read the [original 46-Skill analysis and seven installed additions](docs/SKILLS-46-ANALYSIS.zh-TW.md) for capabilities, engineering use cases, dependencies, and overlap. These are workflow/tool packages, not trained model weights. All seven recommendations in that report are now installed.

## Install on the company computer

Open **PowerShell 7.2 or later** and run:

```powershell
git clone https://github.com/johnson68878-ops/codex-skills-backup.git
Set-Location .\codex-skills-backup
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install.ps1
.\scripts\verify.ps1
```

All 53 entries restore into `%USERPROFILE%\.codex\skills`. On a machine that already has a same-named Skill in `.agents\skills`, compare it before restoring to avoid cross-directory duplicates. Start a new conversation to refresh discovery; restart Codex App if the new Skills do not appear. Installing Skill files does not install their external CLIs or authorize external services.

The installer is conservative:

- An unchanged Skill is skipped.
- A different existing Skill is moved to `%USERPROFILE%\.codex\skills-backup\<timestamp>\` before replacement.
- `.system` and plugin cache directories are never modified.
- Use `.\scripts\install.ps1 -WhatIf` to preview changes.

If `git clone` requests authentication, sign in to GitHub with an account that can access this private repository. You may alternatively download the repository ZIP from GitHub, extract it, and run the same scripts from the extracted folder.

## Verify later

```powershell
Set-Location .\codex-skills-backup
.\scripts\verify.ps1
```

Verification checks every installed personal Skill against the SHA-256 digest stored in `manifests/personal-skills.json`.

## Refresh this backup from a trusted PC

```powershell
Set-Location .\codex-skills-backup
.\scripts\update-backup.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\scripts\verify.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\tests\SkillsBackup.Tests.ps1
.\tests\SkillsHealth.Tests.ps1
.\scripts\Test-SkillsHealth.ps1 -SkillRoots "$env:USERPROFILE\.codex\skills","$env:USERPROFILE\.agents\skills" -ExpectedCount 53 -UseKnownRuntimeRequirements
git status --short
```

Review the changes and security-scan result before committing and pushing.

Omit `-AdditionalSkillsRoot` if there is no additional Skill directory. Duplicate names across roots are rejected before the old snapshot is changed. The additional path is an explicit local input and is not stored in the portable manifest. On a restored machine where all Skills are under `.codex\skills`, the ordinary verification command is sufficient.

`.gitattributes` preserves Skill bytes so Git's newline conversion does not invalidate their digests. The three `planning-with-files` templates omitted by an earlier ignore rule were rebuilt from that Skill's bundled initializer; they are a documented repair, not recovered originals. The manifest records the repaired files.

## Plugin reconnection

After restoring personal Skills, open Codex App and reconnect the plugins you need, such as GitHub, Google Drive and Figma. The inventory in `manifests/plugin-skills.json` documents what was available on the source PC, but it contains no credentials or authorization tokens. See [the dated verification report](docs/verification-2026-09-13.md) for the tested runtimes and remaining sign-in conditions.
