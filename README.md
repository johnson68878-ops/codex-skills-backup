# Codex Skills Backup

Private backup of the personal Codex Skills installed on the Windows PC belonging to `johnson68878-ops`.

This repository vendors personal Skills from `%USERPROFILE%\.codex\skills` and intentionally excludes `.system`, authentication data, conversations, browser profiles, Codex configuration credentials, and plugin caches. Plugin-provided Skills are listed in `manifests/plugin-skills.json`; reconnect those plugins separately in Codex App because their account permissions and MCP services cannot be restored by copying files.

## Install on the company computer

Open PowerShell and run:

```powershell
git clone https://github.com/johnson68878-ops/codex-skills-backup.git
Set-Location .\codex-skills-backup
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install.ps1
.\scripts\verify.ps1
```

Restart Codex App after installation.

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
.\scripts\update-backup.ps1
.\tests\SkillsBackup.Tests.ps1
git status --short
```

Review the changes and security-scan result before committing and pushing.

## Plugin reconnection

After restoring personal Skills, open Codex App and reconnect the plugins you need, such as GitHub and Google Drive. The inventory in `manifests/plugin-skills.json` documents what was available on the source PC, but it contains no credentials or authorization tokens.
